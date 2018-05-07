# frozen_string_literal: true

class Entry < ApplicationRecord
  class Destroyer
    def call(params = {})
      Entry.transaction do
        find_entry(params)
        case params[:mode]
        when 'all'
          destroy_all
        when 'forward'
          destroy_forward
        else
          destroy
        end
      end
      @entry
    end

    private

    attr_accessor :entry

    def find_entry(params)
      @entry = Entry.find_by(user_id: params[:user_id], id: params[:id])
    end

    def destroy_all
      entry&.installments&.map do |target|
        target.destroy
      end
    end

    def destroy_forward
      entry&.entries_forward&.map do |target|
        target.destroy
      end
    end

    def destroy
      replace_entries!(entry) if entry.next_entry.present?
      entry.destroy
    end

    def replace_entries!(entry)
      entry&.next_entry&.update_attributes(entry_id: entry.entry_id)
    end
  end
end
