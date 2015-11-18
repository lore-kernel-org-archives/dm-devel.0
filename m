From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: [PATCH v3 0/7] User namespace mount updates
Date: Wed, 18 Nov 2015 07:23:48 -0500
Message-ID: <564C6DD4.6090308@gmail.com>
References: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com>
 <20151117170556.GV22011@ZenIV.linux.org.uk>
 <20151117172551.GA108807@ubuntu-hedt>
 <20151117175506.GW22011@ZenIV.linux.org.uk> <564B79B1.3040207@gmail.com>
 <20151117191606.GC108807@ubuntu-hedt> <564B941A.2070601@gmail.com>
 <20151117213255.GE108807@ubuntu-hedt>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms080309060802090707060601"
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20151117213255.GE108807@ubuntu-hedt>
Sender: linux-bcache-owner@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
List-Id: dm-devel.ids

This is a cryptographically signed message in MIME format.

--------------ms080309060802090707060601
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-17 16:32, Seth Forshee wrote:
> On Tue, Nov 17, 2015 at 03:54:50PM -0500, Austin S Hemmelgarn wrote:
>> On 2015-11-17 14:16, Seth Forshee wrote:
>>> On Tue, Nov 17, 2015 at 02:02:09PM -0500, Austin S Hemmelgarn wrote:
>>>> On 2015-11-17 12:55, Al Viro wrote:
>>>>> On Tue, Nov 17, 2015 at 11:25:51AM -0600, Seth Forshee wrote:
>>>>>
>>>>>> Shortly after that I plan to follow with support for ext4. I've be=
en
>>>>>> fuzzing ext4 for a while now and it has held up well, and I'm curr=
ently
>>>>>> working on hand-crafted attacks. Ted has commented privately (to o=
thers,
>>>>>> not to me personally) that he will fix bugs for such attacks, thou=
gh I
>>>>>> haven't seen any public comments to that effect.
>>>>>
>>>>> _Static_ attacks, or change-image-under-mounted-fs attacks?
>>>> To properly protect against attacks on mounted filesystems, we'd
>>>> need some new concept of a userspace immutable file (that is, one
>>>> where nobody can write to it except the kernel, and only the kernel
>>>> can change it between regular access and this new state), and then
>>>> have the kernel set an image (or block device) to this state when a
>>>> filesystem is mounted from it (this introduces all kinds of other
>>>> issues too however, for example stuff that allows an online fsck on
>>>> the device will stop working, as will many un-deletion tools).
>>>
>>> Yeah, Serge and I were just tossing that idea around on irc. If we ca=
n
>>> make that work then it's probably the best solution.
>>>
>>>  From a naive perspective it seems like all we really have to do is m=
ake
>>> the block device inode immutable to userspace when it is mounted. And=

>>> the parent block device if it's a partition, which might be a bit
>>> troublesome. We'd have to ensure that writes couldn't happen via any =
fds
>>> already open when the device was mounted too.
>>>
>>> We'd need some cooperation from the loop driver too I suppose, to mak=
e
>>> sure the file backing the loop device is also immutable.
>>>
>>  From a completeness perspective, you'd also need to hook into DM,
>> MD, and bcache to handle their backing devices.  There's not much we
>> could do about iSCSI/ATAoE/NBD devices, and I think being able to
>
> But really no one would be able to mount any of those without
> intervention from a privileged user anyway. The same is true today of
> loop devices, but I have some patches to change that.
Um, no, depending on how your system is configured, it's fully possible=20
to mount those as a regular user with no administrative interaction=20
required.  All that needs done is some udev rules (or something=20
equivalent) to add ACL's to the device nodes allowing regular users to=20
access them (and there are systems I've seen that are naive enough to do =

this).  And I can almost assure you that there will be someone out there =

who decides to directly expose such block devices to a user namespace.


--------------ms080309060802090707060601
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTE4MTIyMzQ4WjBPBgkq
hkiG9w0BCQQxQgRAKwvo5+trUii7la4iy4Slq1ZLv4k8aklvbXOPPu/kF0ot8j02BwdtaxeN
PXlrq7qWmeV2E81/TUcELk5pPBvDOjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCAs0ZgfcO3NO7mraQP+Ze7cFL8cGjJ/iLtYnvt+zCzxe3FpVAL
RcATUdYvczD+OAVW1A2cilfETx9tPpOiwyZX2vc7cCeUOx6K0BQJ2oj/NYOHR5ql3ewoTIry
vOqDGOnmAlbP5eweJvPsQa58AEU1lhjFEu7LgoNkSzZk4zvACjq+ohuGWaTFkION+2mipvO1
nvsM3sleWV3Oy0oEt5sRIw4vNnItPxA6goPxg3wHnrnnfaOo9zOyaFXJUTHKJ632WC/o11BU
/TyFCrYhGwppYloh1yolXwELVOst1IvFMyL/T16J6xZAoyUJ4eAqIDREk5iX4vpM1XhV7pKF
YOXN/6nPjm6UPX2jM5sG+EysVZp1/6HNAf10zLFW3L41OIq2uKYNnJPUXkJG82djeMsMfS/R
j+K4Ok7N6gUpdiGnhLeRUDQ/PJpjqmoA+D8AI+esnyI43IdDh49IdLguWKM2outrJSJgF4Pr
Y9W3wqNeDak2NM2asRnPHVeAoGoZSdEWSLMX493YA/AzpFAC5hTBmf4to4KLxO8PTJs+5kkq
7VFUZR6ok9BLVtvvNcaSdx4CdZDMCJuE3N865lAVRHWXc5adGRKFsBmQBowI4KtGXtqvWPDp
DXuE16cvfpFjs6aYDv5fJ9vMa9IpRLGNVRVZphgAL0aY1VZNv7cdyJLHqAAAAAAAAA==
--------------ms080309060802090707060601--
