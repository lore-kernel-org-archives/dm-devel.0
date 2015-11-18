From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: [PATCH v3 0/7] User namespace mount updates
Date: Wed, 18 Nov 2015 07:46:53 -0500
Message-ID: <564C733D.7010601@gmail.com>
References: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com>
 <20151117170556.GV22011@ZenIV.linux.org.uk>
 <20151117172551.GA108807@ubuntu-hedt>
 <20151117175506.GW22011@ZenIV.linux.org.uk> <564B79B1.3040207@gmail.com>
 <20151117193012.GX22011@ZenIV.linux.org.uk> <564B9074.5030305@gmail.com>
 <20151117210542.GY22011@ZenIV.linux.org.uk>
 <20151117220125.GF108807@ubuntu-hedt>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms020205030405070905090406"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151117220125.GF108807@ubuntu-hedt>
Sender: linux-kernel-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>, Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
List-Id: dm-devel.ids

This is a cryptographically signed message in MIME format.

--------------ms020205030405070905090406
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-17 17:01, Seth Forshee wrote:
> On Tue, Nov 17, 2015 at 09:05:42PM +0000, Al Viro wrote:
>> On Tue, Nov 17, 2015 at 03:39:16PM -0500, Austin S Hemmelgarn wrote:
>>
>>>> This is absolutely insane, no matter how much LSM snake oil you slat=
ter on
>>>> the whole thing.  All of a sudden you are exposing a huge attack sur=
face
>>>> in the place where it would hurt most and as the consolation we are =
offered
>>>> basically "Ted is willing to fix holes when they are found".
>
> None of the LSM changes are intended to protect against attacks from
> these sorts of attacks at all, so that's irrelevant.
>
> As I said before, I'm also working to find holes up front. That plus a
> commitment from the maintainer seems like a good start at least. What
> bar would you set for a given filesystem to be considered "safe enough"=
?
>
>>> For the context of static image attacks, anything that's foun
>>> _needs_ to be fixed regardless, and unless you can find some way to
>>> actually prevent attacks on mounted filesystems that doesn't involve
>>> a complete re-write of the filesystem drivers, then there's not much
>>> we can do about it.  Yes, unprivileged mounts expose an attack
>>> surface, but so does userspace access to the network stack, and so
>>> do a lot of other features that are considered essential in a modern
>>> general purpose operating system.
>>
>> "X is exposes an attack surface.  Y exposes a diferent attack surface.=

>> Y is considered important.  Therefore X is important enough to impleme=
nt it"
>>
>> Right...
>
> That isn't the argument he made. I would summarize the argument as,
> "Saying that X exposes an attack surface isn't by itself enough to
> reject X, otherwise we wouldn't expose anything (such as example Y)."
It's good to see someone understood my meaning...
>
> You believe that the attack surface is too large, and that's
> understandable. Is it your opinion that this is a fundamental problem
> for an in-kernel filesystem driver, i.e. that we can never be confident=

> enough in an in-kernel filesystem parser to allow untrusted data? If
> not, what would it take to establish a level of confidence that you
> would be comfortable with?
While I can't speak for Al's opinion on this, I would like to point out=20
my earlier comment:
 > It's unfeasible from a practical standpoint to expect filesystems to=20
 > assume that stuff they write might change under them due to malicious =

 > intent of a third party.
We can't protect against everything, not without making the system=20
completely unusable for general purpose computing.  There is always some =

degree of trust involved in usage of a computer, the OS has to trust=20
that the hardware works correctly, the administrator has to trust the OS =

to behave correctly, and the users have to trust the administrator.  The =

administrator also needs to have at least some trust in the users,=20
otherwise he shouldn't be allowing them to use the system.

Perhaps we should have an option that can only be enabled on creation of =

the userns that would allow it to use regular kernel mounts, and without =

that option we default to only allowing FUSE and a couple of virtual=20
filesystems (like /proc and devtmpfs).


--------------ms020205030405070905090406
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
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTE4MTI0NjUzWjBPBgkq
hkiG9w0BCQQxQgRASPcPYc4psO/7952jaH6XgNFkRIItnb5hNmSa37sfzSW1VWcQdTB1EjKi
lL4ITN/Gjbop+LE56SWok8+bNQCORzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBjvEty1MnC3m2g3DetLapfSmpk8KmH+pbOUtp0zAB5g5cElY4a
9j3AinkOhOFSwtqbEhPTBXWtjcasxVt8S48QQUBTF7Q4V6eIooEEtXoGV4oLVXoHn3QpKl2z
ph7ohWZJZOVu+qSYR4WNZ8xJzwDNxJGolhu66iN3fp5SIy13biw4cZ8HaGSqse/0CSZDAqdC
1DT0zpaxQDWed2wb4bE2txesBP8OaCgGkMbWEPH9pQQnIozBZ3+64uJZ9hF3v1LFe+C9lRFU
GaQ3BjoG4t3Ndz6PULSj2+U++Qw+laLtTGEwewgaolFn6Ju+Z/bCo/LU9VWUMqdUKwSyT5A/
hE6Qft9mdad7OWPBcEidqEwMjRsB9mgakO2N2W7BkHl9T8MWtkc6oqyIBIOrpAUNV0yOl8Z8
EpFqUUhB0vxBMpyObW9ree9m4Q5GZjaEQH7OfIRGuWYepEXgQPtd6XJFcizAvE8sTD4WCJVM
GsV3yv+5d9A1nz4V8akaDmAdUzb1FBMYfB3ge2SLwdc4MI4jCi2aXjvZMNmrdwrB1DBuwNgD
fWQnwDjE1w66XCphL9KfY//vtqXk9CmHZS12BX2woao7dBhgNGJ/wa7forcsyK1aRJ+a2cly
sUUtRERCBzvtUQ7hpxGTzWf+87i8joHN+MZRpAQaOz/rGVG7Xog1vEesUAAAAAAAAA==
--------------ms020205030405070905090406--
