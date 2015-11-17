From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: [PATCH v3 0/7] User namespace mount updates
Date: Tue, 17 Nov 2015 15:39:16 -0500
Message-ID: <564B9074.5030305@gmail.com>
References: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com>
 <20151117170556.GV22011@ZenIV.linux.org.uk>
 <20151117172551.GA108807@ubuntu-hedt>
 <20151117175506.GW22011@ZenIV.linux.org.uk> <564B79B1.3040207@gmail.com>
 <20151117193012.GX22011@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms000109040700040803070700"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151117193012.GX22011@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Seth Forshee <seth.forshee@canonical.com>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
List-Id: dm-devel.ids

This is a cryptographically signed message in MIME format.

--------------ms000109040700040803070700
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-17 14:30, Al Viro wrote:
> On Tue, Nov 17, 2015 at 02:02:09PM -0500, Austin S Hemmelgarn wrote:
>
>>> _Static_ attacks, or change-image-under-mounted-fs attacks?
>> To properly protect against attacks on mounted filesystems, we'd
>> need some new concept of a userspace immutable file (that is, one
>> where nobody can write to it except the kernel, and only the kernel
>> can change it between regular access and this new state), and then
>> have the kernel set an image (or block device) to this state when a
>> filesystem is mounted from it (this introduces all kinds of other
>> issues too however, for example stuff that allows an online fsck on
>> the device will stop working, as will many un-deletion tools).
>>
>> The only other option would be to force the FS to cache all metadata
>> in memory, and validate between the cache and what's on disk on
>> every access, which is not realistic for any real world system.
>
> Doctor, it hurt when I do it...
>
> IOW, the other option is to refuse attempting this insanity.  Fuse prob=
ably
> can be handled, but being able to mount (with kernel-space drivera) an
> arbitrary ext4 image is equivalent to being able to do anything and it'=
s
> going to stay that way for the forseeable future.  You are talking abou=
t
> a large pile of code that deals with rather convoluted data structure,
> had not been written with validation in mind *and* keeps being develope=
d.
> What's more, that code runs with maximal priveleges there are.
Without factoring in unprivileged mounts, for cases when mounting from a =

block device, you shouldn't have to worry about a malicious third party, =

because their ability to modify it under the filesystem implies that=20
they either already have root privileges, or they have direct access to=20
hardware, and in both cases, your system is already compromised to a=20
degree that makes the reliability of your filesystem irrelevant.  Under=20
the same circumstances with filesystem images, the same statement applies=
=2E

However, while unprivileged mounts make validation more important, there =

is still the fact that if you don't trust someone, then you shouldn't be =

letting them have access to your system.  No amount of sandboxing short=20
of full isolation can solve that, period.  Yes people will try to crack=20
the system, but no matter how much sandboxing there is, it will not be=20
unbreakable unless nobody can access it.

The attack surface is already there, it's just hard to get to.  There's=20
a reason I never mount anything I didn't create myself and can't prove=20
chain of custody on without at least running fsck on it first, and then=20
only mount it with the kernel if there isn't a FUSE driver for it that I =

trust (and GRUB provides a lot of those).
>
> This is absolutely insane, no matter how much LSM snake oil you slatter=
 on
> the whole thing.  All of a sudden you are exposing a huge attack surfac=
e
> in the place where it would hurt most and as the consolation we are off=
ered
> basically "Ted is willing to fix holes when they are found".
For the context of static image attacks, anything that's found _needs_=20
to be fixed regardless, and unless you can find some way to actually=20
prevent attacks on mounted filesystems that doesn't involve a complete=20
re-write of the filesystem drivers, then there's not much we can do=20
about it.  Yes, unprivileged mounts expose an attack surface, but so=20
does userspace access to the network stack, and so do a lot of other=20
features that are considered essential in a modern general purpose=20
operating system.


--------------ms000109040700040803070700
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCC
Brgwgga0MIIEnKADAgECAgMRLfgwDQYJKoZIhvcNAQENBQAweTEQMA4GA1UEChMHUm9vdCBD
QTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNp
Z25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcwHhcN
MTUwOTIxMTEzNTEzWhcNMTYwMzE5MTEzNTEzWjBjMRgwFgYDVQQDEw9DQWNlcnQgV29UIFVz
ZXIxIzAhBgkqhkiG9w0BCQEWFGFoZmVycm9pbjdAZ21haWwuY29tMSIwIAYJKoZIhvcNAQkB
FhNhaGVtbWVsZ0BvaGlvZ3QuY29tMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA
nQ/81tq0QBQi5w316VsVNfjg6kVVIMx760TuwA1MUaNQgQ3NyUl+UyFtjhpkNwwChjgAqfGd
LIMTHAdObcwGfzO5uI2o1a8MHVQna8FRsU3QGouysIOGQlX8jFYXMKPEdnlt0GoQcd+BtESr
pivbGWUEkPs1CwM6WOrs+09bAJP3qzKIr0VxervFrzrC5Dg9Rf18r9WXHElBuWHg4GYHNJ2V
Ab8iKc10h44FnqxZK8RDN8ts/xX93i9bIBmHnFfyNRfiOUtNVeynJbf6kVtdHP+CRBkXCNRZ
qyQT7gbTGD24P92PS2UTmDfplSBcWcTn65o3xWfesbf02jF6PL3BCrVnDRI4RgYxG3zFBJuG
qvMoEODLhHKSXPAyQhwZINigZNdw5G1NqjXqUw+lIqdQvoPijK9J3eijiakh9u2bjWOMaleI
SMRR6XsdM2O5qun1dqOrCgRkM0XSNtBQ2JjY7CycIx+qifJWsRaYWZz0aQU4ZrtAI7gVhO9h
pyNaAGjvm7PdjEBiXq57e4QcgpwzvNlv8pG1c/hnt0msfDWNJtl3b6elhQ2Pz4w/QnWifZ8E
BrFEmjeeJa2dqjE3giPVWrsH+lOvQQONsYJOuVb8b0zao4vrWeGmW2q2e3pdv0Axzm/60cJQ
haZUv8+JdX9ZzqxOm5w5eUQSclt84u+D+hsCAwEAAaOCAVkwggFVMAwGA1UdEwEB/wQCMAAw
VgYJYIZIAYb4QgENBEkWR1RvIGdldCB5b3VyIG93biBjZXJ0aWZpY2F0ZSBmb3IgRlJFRSBo
ZWFkIG92ZXIgdG8gaHR0cDovL3d3dy5DQWNlcnQub3JnMA4GA1UdDwEB/wQEAwIDqDBABgNV
HSUEOTA3BggrBgEFBQcDBAYIKwYBBQUHAwIGCisGAQQBgjcKAwQGCisGAQQBgjcKAwMGCWCG
SAGG+EIEATAyBggrBgEFBQcBAQQmMCQwIgYIKwYBBQUHMAGGFmh0dHA6Ly9vY3NwLmNhY2Vy
dC5vcmcwMQYDVR0fBCowKDAmoCSgIoYgaHR0cDovL2NybC5jYWNlcnQub3JnL3Jldm9rZS5j
cmwwNAYDVR0RBC0wK4EUYWhmZXJyb2luN0BnbWFpbC5jb22BE2FoZW1tZWxnQG9oaW9ndC5j
b20wDQYJKoZIhvcNAQENBQADggIBADMnxtSLiIunh/TQcjnRdf63yf2D8jMtYUm4yDoCF++J
jCXbPQBGrpCEHztlNSGIkF3PH7ohKZvlqF4XePWxpY9dkr/pNyCF1PRkwxUURqvuHXbu8Lwn
8D3U2HeOEU3KmrfEo65DcbanJCMTTW7+mU9lZICPP7ZA9/zB+L0Gm1UNFZ6AU50N/86vjQfY
WgkCd6dZD4rQ5y8L+d/lRbJW7ZGEQw1bSFVTRpkxxDTOwXH4/GpQfnfqTAtQuJ1CsKT12e+H
NSD/RUWGTr289dA3P4nunBlz7qfvKamxPymHeBEUcuICKkL9/OZrnuYnGROFwcdvfjGE5iLB
kjp/ttrY4aaVW5EsLASNgiRmA6mbgEAMlw3RwVx0sVelbiIAJg9Twzk4Ct6U9uBKiJ8S0sS2
8RCSyTmCRhJs0vvva5W9QUFGmp5kyFQEoSfBRJlbZfGX2ehI2Hi3U2/PMUm2ONuQG1E+a0AP
u7I0NJc/Xil7rqR0gdbfkbWp0a+8dAvaM6J00aIcNo+HkcQkUgtfrw+C2Oyl3q8IjivGXZqT
5UdGUb2KujLjqjG91Dun3/RJ/qgQlotH7WkVBs7YJVTCxfkdN36rToPcnMYOI30FWa0Q06gn
F6gUv9/mo6riv3A5bem/BdbgaJoPnWQD9D8wSyci9G4LKC+HQAMdLmGoeZfpJzKHMYIE0TCC
BM0CAQEwgYAweTEQMA4GA1UEChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNl
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTE3MjAzOTE2WjBPBgkq
hkiG9w0BCQQxQgRAgWLQKSK5kP8D6BGKlbwbql8eYDGGiWgCsvIjRsWw/U2dVnI+bbF2wnnU
Ju9luT8xkNpFVg5ZApEDeR+Xw9vuHDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAPs7FZzchyR+5y0iaQOqUDiiB4if9JKfA9hDkOR5D8VkzpEc3Y
Y0plNRRB1vWTwcxFHsDCGNhOC65I27BO2YsxegbxRfbpefK547CmQuzOp66Rm60VaKA9tS9E
CXt8v7CKjNeub1ZE6dle/6PDrPi/gevUNv0mLiCP04nT0S8J1XMTtIHGPlr6sJRp7S19M04U
ST6kVwc5O1Pvn85bcgo+wER2kDeGjXPMFd9auHMvn2iVxSMGp74z98aNs2Uow+zC06Mm+7Pq
TqZb6N8G4FGwQvhKTUeK4TYoXc/etYF4kKT7jz5wY622KNJDRboFufpYItdBCpLVuXRFsr8P
1rNPRXwcHfaOIfUMhiqd3h1Ou8gtmExF5bJo5GvDIjkjDRKYXi8//dtTFxMvGrc7FIKbmpp6
mOpmWkKnWESeqzEwae5ogRAPCi6FtrvlC5slhbKoGjdXBOfhqRxwe2dKNdNyYEczRyl0c5nb
Gphhv6rsnx+PQ1SnEKqTLup+juRoUxBZq1PivcUwjxDcMisGrs0sJUPFk2bsJZWtJLQ8q98p
/PryRK8rEBO+gLV6Y0Cl4UWcMmIkC23CMhhkAGE9HMNFqnYQsGaEel9nvPOyT1SoZ1DFiFuQ
tEWqGS98HVGYgsECwMJ0QR2GtVkKDPlzd4nmVdkVCElnzdk/dsfPjwG5yQAAAAAAAA==
--------------ms000109040700040803070700--
