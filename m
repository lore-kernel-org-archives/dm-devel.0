From: Michael Menge <michael.menge@zdv.uni-tuebingen.de>
Subject: default path for iSCSI
Date: Thu, 11 Oct 2012 11:40:02 +0200
Message-ID: <20121011114002.11762w253syd9h4i@webmail.uni-tuebingen.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4003520160049482789=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a cryptographically signed message in MIME format.

--===============4003520160049482789==
Content-Type: multipart/signed; boundary="=_1rdthp7m5qlek";
	protocol="application/pkcs7-signature"; micalg="sha1"
Content-Transfer-Encoding: 7bit

This is a cryptographically signed message in MIME format.

--=_1rdthp7m5qlek
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

first, I hope that I have found the correct list for this question,
as it is not really a devel but a multipath user question.

I want to build a ha-cluster for kvm-virtualisation. I have some blades
and each blade has two network interfaces. The storage for the virtual
machines is provides by two iSCSIs systems which are connected with =20
two interfaces each.

My plan was that the iSCSI-traffic should use the second interface by
default, and only use the first interface, if the second path is down,
as the first network interface is used by the other network traffic.

Consulting the manpage and the net i found that setting
path_grouping_policy to group_by_prio and setting the priority
for the default path higher than the other path should do
the trick.

I could set the priority with prio weightedpath, but the
Host part of the HBTL is different on some blades as are the
device names. I would like to use the same multipath config
on all blades and i am certain that both the HBTL and the device name
may change on reboot. Before version 0.4.9 there was the option to
configure prio_callout and use a script to set the priority but that's
not possible any more.

Is there a way to use /dev/disk/by-path in weightedpath?
Is it possible to write my own priority routine and still to use the
multipath package from the distribution? If so is there any =20
documentation/examples how to do this?


Regards

Michael Menge




---------------------------------------------------------------------------=
-----

M.Menge                                Tel.: (49) 7071/29-70316
Universit=C3=A4t T=C3=BCbingen                   Fax.: (49) 7071/29-5912
Zentrum f=C3=BCr Datenverarbeitung          mail: =20
michael.menge@zdv.uni-tuebingen.de
W=C3=A4chterstra=C3=9Fe 76
72074 T=C3=BCbingen
--=_1rdthp7m5qlek
Content-Type: application/pkcs7-signature;
 name="smime.p7s"
Content-Description: S/MIME Signatur
Content-Disposition: attachment;
 filename="smime.p7s"
Content-Transfer-Encoding: base64

MIIUjwYJKoZIhvcNAQcCoIIUgDCCFHwCAQExCzAJBgUrDgMCGgUAMAsGCSqGSIb3DQEHAaCCEf8w
ggUlMIIEDaADAgECAgIA9TANBgkqhkiG9w0BAQUFADB3MQswCQYDVQQGEwJERTEfMB0GA1UEChMW
VW5pdmVyc2l0YWV0IFR1ZWJpbmdlbjEdMBsGA1UECxMUTG9jYWxTVUItVU5JVFVFLUNBMDExKDAm
BgNVBAMTH0xvY2FsU1VCLVVOSVRVRS1DQTAxIENBLUNlcnQgMDEwHhcNMTAwODI2MTMzMDU0WhcN
MTUwODI1MTMzMDU0WjB1MQswCQYDVQQGEwJERTEfMB0GA1UEChMWVW5pdmVyc2l0YWV0IFR1ZWJp
bmdlbjEWMBQGA1UEAxMNTWljaGFlbCBNZW5nZTEtMCsGCSqGSIb3DQEJARYebWljaGFlbC5tZW5n
ZUB1bmktdHVlYmluZ2VuLmRlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxcH6IOtd
pM1ndNX02ScqbAkKBdylcE9F6/cp/IiZF/BxzJoXJoNNls5SY/4IX2Wkx1p5YT9G8XaR1QA2iF/f
Y5r6+hPb03R+dc4CJm8sO6Lve1h3UYtQoEnC36ITKePAILgVnc1+7FChsRy/elvGWd+ypI4a2B+y
Bow2b6ljvJlqyG66G2X+0qn4nC4Sd2oCF/iXP+k12SJh+aBPJiBwC8UUqXLM/DVNNGjuk7nGlHq5
ta4TQvL1JWv4ouRI1mgFB5Xidq30lHUtSxYaXa0naD+efHbPsJE6oQMvJUxegzaGwRa2Jln7HDF7
a+8ruEmDilvHk3ZtaVxND+wB9cHk8QIDAQABo4IBuzCCAbcwHQYDVR0OBBYEFBpkw8IAL/0lmOkT
9TOXEs4p7RVvMIGZBgNVHSMEgZEwgY6AFNZouQqJUvlMZTfaTQXBVKMGGqSvoXOkcTBvMQswCQYD
VQQGEwJERTEfMB0GA1UEChMWVW5pdmVyc2l0YWV0IFR1ZWJpbmdlbjEYMBYGA1UECxMPTG9jYWwt
VU5JVFVFLUNBMSUwIwYDVQQDExxMb2NhbC1VTklUVUUtQ0EgUm9vdC1DZXJ0IDAxggECMAwGA1Ud
EwEB/wQCMAAwCwYDVR0PBAQDAgSwMCkGA1UdEQQiMCCBHm1pY2hhZWwubWVuZ2VAdW5pLXR1ZWJp
bmdlbi5kZTAJBgNVHRIEAjAAMFUGA1UdHwROMEwwSqBIoEaGRGh0dHA6Ly93d3cuY2EudW5pLXR1
ZWJpbmdlbi5kZS93aWRlcnJ1Zi9jcmwtTG9jYWxTVUItVU5JVFVFLUNBMDEuY3JsMFIGCCsGAQUF
BwEBBEYwRDBCBggrBgEFBQcwAoY2aHR0cDovL3d3dy5jYS51bmktdHVlYmluZ2VuLmRlL2FpYS9s
b2NhbHN1YndlYmNhMDEuY3J0MA0GCSqGSIb3DQEBBQUAA4IBAQB4878yw2g8IzMc/j8lOa7ZLGby
M6CoKT6zabVM/QXtXhfdKu3T2+Q/B0ypbH4qVGR3xOT7pvieEuHUA+hsddwPuxFbDhZ+bAypk7HD
PP7foXULLdfDPr3H1UW7umxtTGBsvCPBiiKZQWLemCcbz5DdRIQidrssCdJkfaEL61bJj0YT0gCG
O1t5hcskQH03701EhmEURH0kvV1eEV24qEhIjr/xrAMw8Ij3hPCW0Xe82DdQXg5BVTk9oGf/9Kw6
YJeU+LfwuiZU18X6foScm319oN3HYaE4RzMhxoOUceYU/NBnxm/OKsr+wh4FRzZYOszfhpYFuNVY
R3ikxLJoHV0rMIIFCjCCA/KgAwIBAgIECeagADANBgkqhkiG9w0BAQUFADBaMQswCQYDVQQGEwJE
RTETMBEGA1UEChMKREZOLVZlcmVpbjEQMA4GA1UECxMHREZOLVBLSTEkMCIGA1UEAxMbREZOLVZl
cmVpbiBQQ0EgR2xvYmFsIC0gRzAxMB4XDTA3MDIwNTEyMjYyNloXDTE5MDIwNDAwMDAwMFowdzEL
MAkGA1UEBhMCREUxHzAdBgNVBAoTFlVuaXZlcnNpdGFldCBUdWViaW5nZW4xHDAaBgNVBAMTE0ds
b2JhbC1VTklUVUUtQ0EgMDExKTAnBgkqhkiG9w0BCQEWGnVuaXR1ZS1jYUB1bmktdHVlYmluZ2Vu
LmRlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAstu5y8Xi/5mzRLhv+viYrQ/c/CIL
ZeelQ6zZtE55lDBDXYqBWaInwCTG+Su8/tdJRyk7EDYMsjpzTESUDa9kYgvb28Llwlnbu4VBveEo
4jnpZnf/fo7yfcscJESl6Zif7TIWXBtgkNU/CvkWNMzylbCT+k/vfIfSYaWrAbUIWAVBNcZTPU0D
2bYKPz82XZ57Z0t1hKlYPuutSChmtWuwSwMU9CeScuwEbP9X16fveLdT4B9ntKmRpWnCPZHsDmvC
PfU7HsZJFbIbUwoxjrSWTK0cP6I3mHrrdWl3h/INTNAHQYAmGGmn70As58T7eYj3W2QbltW9igAo
lPsKRvJxKQIDAQABo4IBuTCCAbUwDwYDVR0TAQH/BAUwAwEB/zALBgNVHQ8EBAMCAQYwHQYDVR0O
BBYEFLDBu2g1f+LWQZwaca/g/EE0zcOoMB8GA1UdIwQYMBaAFEm3xs/oPR9/6kR7Eyn38QpwPt5k
MCUGA1UdEQQeMByBGnVuaXR1ZS1jYUB1bmktdHVlYmluZ2VuLmRlMIGIBgNVHR8EgYAwfjA9oDug
OYY3aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1jYS9wdWIvY3JsL2NhY3JsLmNy
bDA9oDugOYY3aHR0cDovL2NkcDIucGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1jYS9wdWIvY3JsL2Nh
Y3JsLmNybDCBogYIKwYBBQUHAQEEgZUwgZIwRwYIKwYBBQUHMAKGO2h0dHA6Ly9jZHAxLnBjYS5k
Zm4uZGUvZ2xvYmFsLXJvb3QtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MEcGCCsGAQUFBzAChjto
dHRwOi8vY2RwMi5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1Yi9jYWNlcnQvY2FjZXJ0LmNy
dDANBgkqhkiG9w0BAQUFAAOCAQEAabQg/8E0LpmKYvAPoK9XFXK3y1lmlTIWg6L0UZzyy0O2Gv8p
/ryXsnp8sEPqoPJ5wZGcqukzU0eRHPdb4VigreeuYMZNMcfp9+ldWmG9Jzk/5a4OXNh9FbWokOeI
15odtWw0ldZ9pmj3HSK+R+996BTF3AA7n5lTNQjkIDp16ovbpD7LQO37/AchQ7ZMNvIMeSwe7Vl/
znPaU6vNs50n1H8Tz1varD8G5glqqX96fT23AloL8++PmkfW6d6eL3rEQIE9XpzDqm4aIMB5ose/
URHv5lotawCKdUR0gv3dJNEEpBGbVvX4noF0whz8xx/OTqfiU52VTdLEr3qULlJ9OzCCBCEwggMJ
oAMCAQICAgDHMA0GCSqGSIb3DQEBBQUAMHExCzAJBgNVBAYTAkRFMRwwGgYDVQQKExNEZXV0c2No
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
VGeNucGM94dgBDAlOWGwFP7csP4/c7Q=

--=_1rdthp7m5qlek--


--===============4003520160049482789==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4003520160049482789==--
