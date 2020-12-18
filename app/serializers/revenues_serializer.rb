class RevenuesSerializer
  def self.serialize_data(data)
    {
      'data': {
          'id': data.id,
          'attributes': {
            'revenue': data.revenue
          }
        }
      }
  end
end
