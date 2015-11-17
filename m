From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: [PATCH v3 0/7] User namespace mount updates
Date: Tue, 17 Nov 2015 14:02:09 -0500
Message-ID: <564B79B1.3040207@gmail.com>
References: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com>
 <20151117170556.GV22011@ZenIV.linux.org.uk>
 <20151117172551.GA108807@ubuntu-hedt>
 <20151117175506.GW22011@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms030908080306040908010908"
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20151117175506.GW22011@ZenIV.linux.org.uk>
Sender: linux-bcache-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>, Seth Forshee <seth.forshee@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
List-Id: dm-devel.ids

This is a cryptographically signed message in MIME format.

--------------ms030908080306040908010908
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-17 12:55, Al Viro wrote:
> On Tue, Nov 17, 2015 at 11:25:51AM -0600, Seth Forshee wrote:
>
>> Shortly after that I plan to follow with support for ext4. I've been
>> fuzzing ext4 for a while now and it has held up well, and I'm currentl=
y
>> working on hand-crafted attacks. Ted has commented privately (to other=
s,
>> not to me personally) that he will fix bugs for such attacks, though I=

>> haven't seen any public comments to that effect.
>
> _Static_ attacks, or change-image-under-mounted-fs attacks?
To properly protect against attacks on mounted filesystems, we'd need=20
some new concept of a userspace immutable file (that is, one where=20
nobody can write to it except the kernel, and only the kernel can change =

it between regular access and this new state), and then have the kernel=20
set an image (or block device) to this state when a filesystem is=20
mounted from it (this introduces all kinds of other issues too however,=20
for example stuff that allows an online fsck on the device will stop=20
working, as will many un-deletion tools).

The only other option would be to force the FS to cache all metadata in=20
memory, and validate between the cache and what's on disk on every=20
access, which is not realistic for any real world system.

It's unfeasible from a practical standpoint to expect filesystems to=20
assume that stuff they write might change under them due to malicious=20
intent of a third party.  Some filesystems may be more resilient to this =

kind of attack (ZFS and BTRFS in some configurations come to mind), but=20
a determined attacker can still circumvent those protections (on at=20
least BTRFS, it's not all that hard to cause a sub-tree of the=20
filesystem to disappear with at most two 64k blocks being written to the =

block device directly, and there is no way that this can be prevented=20
short of what I suggest above).


--------------ms030908080306040908010908
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTE3MTkwMjA5WjBPBgkq
hkiG9w0BCQQxQgRArSbuClGwiYYBY7Edkyh2RVHmxA4OFwctsWEkbtCiDnZSCoyOvCLzFYCC
4uM3HQcC+dkmo/mbRhifnGlhVTf8IzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAw/vRVQ7ZnE1D98dCOLVaBz38S+JLgn5ha3z/2ZIbGO4OTBRt8
L1CKUldx5LZzZJ22LTwgdaQyI3/gQiAXqIhGFx0LJ+/mgpyNsTaknjH6GWavFKsHWWoczMhZ
BGZYSNstMnJXhWHCcvg7gQMbLCteKCZQ7YNl/s2qW2/6UrIoucijxaMu3UFxorAmyWyxTioU
VXHEMMx76TVPFEJnVQqisI7QgnXbpNH6A8RoHkaIvkTpoiLGNpFqRPf7/UOqqIGNzBoGJQy3
JjR7H4mWKllcmnlcO93y5Slt/RFsIF2FTaNbYEiKQsjFhC5uTXUAdvG0yfzvD9WpLYUa7+V2
Zy63JhnbGrE43ym4GvZjxd/NsgEe+8PbZb7IJSXWzHzTDZAZ49w7KDfu5+5fcj7HT2grVKAi
JlMEBHQXSuUTJR5n/YVTj7Or0t/6gw+ZbSvWDP9LCKV8/Vb0VvfzRCJVLpU6YsuejBeWLokU
VzQ6rsKCTNT0Qkaia7Agw0HrOqpgwMVmbj2kD/s7Qd5U20sJduJMq0oufNAu5hvOiMGkU7vV
VZzEJNJwd20rfE+mDTpoSsjqAFCGySny5grhMO0r53CZPLgg/LZXNaxZH84MtcQg8XWXAR/F
PuSmj3Jov80bnMVY76VD4G8j8gAaKkFmiUN9JVRm7dnWdK1F2pHYNYlwdAAAAAAAAA==
--------------ms030908080306040908010908--
