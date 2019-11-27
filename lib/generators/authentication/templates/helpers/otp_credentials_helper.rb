# frozen_string_literal

# Helper for one-time-password authentication methods
#
# Automatically generated by the orthodox gem (https://github.com/katanacode/orthodox)
# (c) Copyright 2019 Katana Code Ltd. All Rights Reserved. 
module OtpCredentialsHelper

  require 'rqrcode'

  # SVG code for a given OtpCredential. Use this to add a QR code to a page
  #
  # otp_credential - An OtpCredential to show the SVG for.
  #
  # Retuns String of valid HTML
  def svg_url_for_otp_credential(otp_credential)
    qrcode = qrcode(otp_credential)
    qrcode.as_svg({
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 3,
      standalone: true      
    }).html_safe
  end

  private
  
  def qrcode(otp_credential)
    RQRCode::QRCode.new(otp_credential.url)
  end
    
end
