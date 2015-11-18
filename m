From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: [PATCH v3 0/7] User namespace mount updates
Date: Wed, 18 Nov 2015 10:38:58 -0500
Message-ID: <564C9B92.5080107@gmail.com>
References: <1447778351-118699-1-git-send-email-seth.forshee@canonical.com>
 <20151117170556.GV22011@ZenIV.linux.org.uk>
 <20151117172551.GA108807@ubuntu-hedt>
 <20151117175506.GW22011@ZenIV.linux.org.uk> <564B79B1.3040207@gmail.com>
 <20151117193012.GX22011@ZenIV.linux.org.uk> <564B9074.5030305@gmail.com>
 <20151117210542.GY22011@ZenIV.linux.org.uk>
 <20151117220125.GF108807@ubuntu-hedt> <564C733D.7010601@gmail.com>
 <20151118143022.GC134139@ubuntu-hedt>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms060705090801050202020809"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20151118143022.GC134139@ubuntu-hedt>
Sender: owner-linux-security-module@vger.kernel.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
List-Id: dm-devel.ids

This is a cryptographically signed message in MIME format.

--------------ms060705090801050202020809
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-18 09:30, Seth Forshee wrote:
> On Wed, Nov 18, 2015 at 07:46:53AM -0500, Austin S Hemmelgarn wrote:
>> On 2015-11-17 17:01, Seth Forshee wrote:
>>> On Tue, Nov 17, 2015 at 09:05:42PM +0000, Al Viro wrote:
>>>> On Tue, Nov 17, 2015 at 03:39:16PM -0500, Austin S Hemmelgarn wrote:=

>>>>
>>>>>> This is absolutely insane, no matter how much LSM snake oil you sl=
atter on
>>>>>> the whole thing.  All of a sudden you are exposing a huge attack s=
urface
>>>>>> in the place where it would hurt most and as the consolation we ar=
e offered
>>>>>> basically "Ted is willing to fix holes when they are found".
>>>
>>> None of the LSM changes are intended to protect against attacks from
>>> these sorts of attacks at all, so that's irrelevant.
>>>
>>> As I said before, I'm also working to find holes up front. That plus =
a
>>> commitment from the maintainer seems like a good start at least. What=

>>> bar would you set for a given filesystem to be considered "safe enoug=
h"?
>>>
>>>>> For the context of static image attacks, anything that's foun
>>>>> _needs_ to be fixed regardless, and unless you can find some way to=

>>>>> actually prevent attacks on mounted filesystems that doesn't involv=
e
>>>>> a complete re-write of the filesystem drivers, then there's not muc=
h
>>>>> we can do about it.  Yes, unprivileged mounts expose an attack
>>>>> surface, but so does userspace access to the network stack, and so
>>>>> do a lot of other features that are considered essential in a moder=
n
>>>>> general purpose operating system.
>>>>
>>>> "X is exposes an attack surface.  Y exposes a diferent attack surfac=
e.
>>>> Y is considered important.  Therefore X is important enough to imple=
ment it"
>>>>
>>>> Right...
>>>
>>> That isn't the argument he made. I would summarize the argument as,
>>> "Saying that X exposes an attack surface isn't by itself enough to
>>> reject X, otherwise we wouldn't expose anything (such as example Y)."=

>> It's good to see someone understood my meaning...
>>>
>>> You believe that the attack surface is too large, and that's
>>> understandable. Is it your opinion that this is a fundamental problem=

>>> for an in-kernel filesystem driver, i.e. that we can never be confide=
nt
>>> enough in an in-kernel filesystem parser to allow untrusted data? If
>>> not, what would it take to establish a level of confidence that you
>>> would be comfortable with?
>> While I can't speak for Al's opinion on this, I would like to point
>> out my earlier comment:
>>> It's unfeasible from a practical standpoint to expect filesystems
>> to > assume that stuff they write might change under them due to
>> malicious > intent of a third party.
>
> So maybe the first requirement is that the user cannot modify the
> backing store directly while the device is mounted.
>
>> We can't protect against everything, not without making the system
>> completely unusable for general purpose computing.  There is always
>> some degree of trust involved in usage of a computer, the OS has to
>> trust that the hardware works correctly, the administrator has to
>> trust the OS to behave correctly, and the users have to trust the
>> administrator.  The administrator also needs to have at least some
>> trust in the users, otherwise he shouldn't be allowing them to use
>> the system.
>>
>> Perhaps we should have an option that can only be enabled on
>> creation of the userns that would allow it to use regular kernel
>> mounts, and without that option we default to only allowing FUSE and
>> a couple of virtual filesystems (like /proc and devtmpfs).
>
> I've considered the idea of something more global like a sysctl, or a
> per-filesystem knob in sysfs. I guess a per-container knob is another
> option, I'm not sure what interface we use to expose it though.
>
The most useful way I can see of implementing this would be to have an=20
option on container creation that controls whether kernel mounts are=20
allowed or not (possibly have it allow any of {no mounts, only FUSE=20
mounts, all mounts}), and then have a sysctl to set the default for=20
containers created without this option (and possibly one to force all=20
containers to ignore the option, and just use the default).


--------------ms060705090801050202020809
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTE4MTUzODU4WjBPBgkq
hkiG9w0BCQQxQgRAmrR6F+J7NBGwQDMe3SaA30w7cGT30cnT46go9VcmEJMvMjyrS9lGjY0/
cXws78PY1iZEPis2YikN7TX8R19xoDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgB+A43rgifPMWV9ELiBa9jKSWTrvkEoi50h4VJJgiqcvbBxHOW2
ODoGP/CALQ3pCfAZhl/FZ1vsoHP8C6fXn2e1Z/rwV7mLlMalTvR6f54JIWILVtpmw2MPDiFF
s2M2qeP5NrgFyHEnA6RRIXaCAU9faZ4V7yvKHjcvegzYNMhgNqTe989rUvrC7oS4+rNaewCd
B15r6Sev1OxSOLyyYeGPpVBeOVU2nOoNSB4yg625cTZ+iwSm/9rT09PuaE0Zc8y/yg6b3V/X
dSCrFetn6M601dcf5Lf1GQnmbNQCOFwnC+FBl9paKE5pL4bMTMcHuqfTWr5F9WHFNwP5yPKb
F/nq0l2O+6sEJtYvQxlivhcEEKaK3+ZqB4cymzDebpdH7p0AfCEbHRfiUv5/PI9IdoLzRkxj
r1PIiXDErkrky5PzwWGWoxT3LVDnMjDuF+P2fnobAtMxmXt7G9ihgDdf2WVNG9/DXwp5hOQt
+tXALgo3D54zfh9BcUWAzUirze6rUYIKlvtUvq6t5hoXuKDaMabmQ+c9qsE6hLUUx7sgmIh2
0FB6cV+QFDZnP8JYulJIWkzi1903vUeJhV9oT7R62zHFtdm3IVuj1B4MVswqLq2MD4mZTpVl
zZepuZAB2ehc+I0KqS3Q6IuqICTCK1U7BEEs8rcASgvrKjOVB3aKnn0FwQAAAAAAAA==
--------------ms060705090801050202020809--
