From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: [PATCH v3 0/7] User namespace mount updates
Date: Wed, 18 Nov 2015 10:34:57 -0500
Message-ID: <564C9AA1.30509@gmail.com>
References: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com>
 <20151117170556.GV22011@ZenIV.linux.org.uk>
 <20151117172551.GA108807@ubuntu-hedt>
 <20151117175506.GW22011@ZenIV.linux.org.uk> <564B79B1.3040207@gmail.com>
 <20151117191606.GC108807@ubuntu-hedt> <564B941A.2070601@gmail.com>
 <20151117213255.GE108807@ubuntu-hedt> <564C6DD4.6090308@gmail.com>
 <20151118142238.GB134139@ubuntu-hedt>
 <20151118145818.GC22011@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms010903060509090202070501"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151118145818.GC22011@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>, Seth Forshee <seth.forshee@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
List-Id: dm-devel.ids

This is a cryptographically signed message in MIME format.

--------------ms010903060509090202070501
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-18 09:58, Al Viro wrote:
> On Wed, Nov 18, 2015 at 08:22:38AM -0600, Seth Forshee wrote:
>
>> But it still requires the admin set it up that way, no? And aren't
>> privileges required to set up those devices in the first place?
>>
>> I'm not saying that it wouldn't be a good idea to lock down the backin=
g
>> stores for those types of devices too, just that it isn't something th=
at
>> a regular user could exploit without an admin doing something to
>> facilitate it.
>
> Sigh...  If it boils down to "all admins within all containers must be
> trusted not to try and break out" (along with "roothole in any containe=
r
> escalates to kernel-mode code execution on host"), then what the fuck
> is the *point* of bothering with containers, userns, etc. in the first
> place?  If your model is basically "you want isolation, just use kvm",
> fine, but where's the place for userns in all that?
In this case, Seth is referring to the host admin, not the container admi=
n.
>
> And if you are talking about the _host_ admin, then WTF not have him ju=
st
> mount what's needed as part of setup and to hell with mounting those
> inside the container?
This is decidedly non-trivial to handle in some cases.  IIRC, one of the =

particular things that sparked this in the first place was the Chrome=20
Native Client having to have CAP_SYS_ADMIN or SUID set on it to handle=20
setting up it's own sandbox, which is not something that should ever be=20
set on an executable that runs untrusted code (which is the whole point=20
of NaCl).
>
> Look at that from the hosting company POV - they are offering a bunch o=
f
> virtual machines on one physical system.  And you want the admins on th=
ose
> virtual machines independent from the host admin.  Fine, but then you
> really need to keep them unable to screw each other or gain kernel-mode=

> execution on the host.
>
> Again, what's the point of all that?  I assumed the model where contain=
ers
> do, you know, contain what's in them, regardless of trust.  You guys se=
em
> to assume something different and I really wonder what it _is_...
Yes, hosting and isolation of untrusted code are valid uses for=20
containers, which is why I suggested the ability to disallow mounts=20
other than FUSE, and make that the default state.  There are other=20
perfectly valid uses for them as well, and for me the two I'm=20
particularly interested in are safe deployment of a new system from an=20
existing system (ala Gentoo or Arch installation, or manual installation =

of *BSD), and running non-native distros without virtualization (On a=20
single user system, virtualization is overkill when all you want is a=20
Debian or Fedora or Arch testing environment and don't care about their=20
specific kernel features).


--------------ms010903060509090202070501
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTE4MTUzNDU3WjBPBgkq
hkiG9w0BCQQxQgRAk+C0OG9ZcnD0KtNUBNFkDF2Aa8lZwDRNgeFJWmH118VLygWZfVAeEpbO
yAG0EfJxCxVs9v9Tk5Go5HkFktzWBjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCGzYhx1Tk6iZpREa4o5OV0xMTkJEXn05/x3ROrfQXBhI3H4zT6
jXFo6NQUU4nV/qv1gSBevZm7A9Ugq/VrKwFmyMXWgbLxxJbvaNvpJpODXW+cHAp8LPDmraMw
OoTqET9ajWAgsa2S7N0rG+ogKL8rXYosN6yq9qUeJqKXtmS7v7AqiLQggy6Lu8Ybm5OFXpOP
jdhGWARf+8wMHiyk9bzlfSCf+Q41ZmLqP48RqQWrAIgY56axJqsPYXm0nw+ls0zYYniQJPDq
BaYTavB6c4Pb+ejyx3YLVT8ebTms4Xd12Hk6xhP1mWCNEsWenc1bYSTC49ymE2FyxUHhtLt7
fO25PUUm7hMyza23LpxJpMk9O+8UXVO4L55rHo+m1RcYeoFNl/KEdO9+nu/SWs6hhp5rhw0K
Ud6WMqGsMNqnsm2Iv19RC6yvrjcgD9sbaOEUC4YU8WxVE0rNCj3IZhAyXwrQhyKdSHL4qmNZ
L9ElJ923kWMDsVg8g6nZS27CuJkbLi1AoUp//Kqq9eolrTZtPLS9g26tnpBoRmUvn1NXcP2X
2ky9jkVPMRpuIt+SnqyAyXNSLEq2ynQpIWEVGHaHL/RSP5CD1GdRFU8C8QZdZ+uQGzJibkO6
ySLIz3Rzl5VrQ0zGc0Kme4WMT0oX5+OmSQeN/W1AwZ7oUDz1c8/wtAKofgAAAAAAAA==
--------------ms010903060509090202070501--
