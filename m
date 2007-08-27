From: Tore Anderson <tore@linpro.no>
Subject: Re: dm-rdac not working?
Date: Mon, 27 Aug 2007 20:31:38 +0200
Message-ID: <46D3188A.3090405@linpro.no>
References: <46D2E298.1020702@linpro.no>
	<1188236026.9504.10.camel@linuxchandra>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010406010507040709040802"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1188236026.9504.10.camel@linuxchandra>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------010406010507040709040802
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

* Chandra Seetharaman

> What version of multipath tools are you using ?

   0.4.7.

> Can you attach your multipath.conf file. You should be using the rdac
> path checker instead of the tur path checker.

   Hmm, this was added in 0.4.8...  What's the difference between the
  rdac path checker and the tur checker?  Anyway, it appears to me that
  the problem here is with the kernel hardware handler, not in the
  userspace path checker, wouldn't you agree?  The hardware handler is
  invoked unpon pg init as expected, but fails to do its job.

> Can you attach the o/p of "multipath -ll"

mysql (3600a0b80002984ae0000179c46a68843)
[size=20 GB][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=0][enabled]
  \_ 3:0:0:1 sdd 8:48  [active][ready]
  \_ 4:0:0:1 sdh 8:112 [active][ready]
\_ round-robin 0 [prio=6][active]
  \_ 3:0:1:1 sdg 8:96  [active][ready]
  \_ 4:0:1:1 sdj 8:144 [active][ready]
www (3600a0b80002984ae0000179b46a687fb)
[size=45 GB][features=1 queue_if_no_path][hwhandler=1 rdac]
\_ round-robin 0 [prio=0][enabled]
  \_ 3:0:0:0 sdc 8:32  [active][ready]
  \_ 4:0:0:0 sde 8:64  [active][ready]
\_ round-robin 0 [prio=6][active]
  \_ 3:0:1:0 sdf 8:80  [active][ready]
  \_ 4:0:1:0 sdi 8:128 [active][ready]

   This is after the machine has booted, so things have changed around a
  little.  3:0:0:1 and 4:0:0:0 has switched devices, but otherwise it
  looks like it did when I generated the problem.

> I presume 8:64 and 8:112 are the devices corresponding to other paths of
> the device.

   That's right.

> You can see that the MODE_SELECT command is sent and immediately the
> path is failed (which means the MODE_SELECT command has failed).
> 
> And this the same thing that repeats below.

   Yes.  It appears to me it's sending that MODE_SELECT (which I guess is
  like dm-emc's "trespass"?) command when it's  trying to activate the
  pg, but it simply doesn't work, so it's retrying over and over again,
  but in vain.  And after a while ext3 gets remounted r/o and it's game
  over.

Regards
-- 
Tore Anderson

--------------010406010507040709040802
Content-Type: text/plain;
 name="multipath.conf"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="multipath.conf"

IyBUaGlzIGZpbGUgaXMgbWFuYWdlZCBieSBwdXBwZXQsIGFueSBsb2NhbCBjaGFuZ2VzIHdp
bGwgYmUgbG9zdAoKZGVmYXVsdHMgewoJdXNlcl9mcmllbmRseV9uYW1lcwl5ZXMKfQoKZGVm
YXVsdHMgewoJbXVsdGlwYXRoX3Rvb2wJCSIvc2Jpbi9tdWx0aXBhdGggLXYwIgoJdWRldl9k
aXIJCS9kZXYKCXBvbGxpbmdfaW50ZXJ2YWwJMTAKCXJyX3dtaW5faW8JCTEwMAp9CgpibGFj
a2xpc3QgewoJZGV2bm9kZQkJCSJeKHJhbXxyYXd8bG9vcHxmZHxtZHxkbS18c3J8c2NkfHN0
KVswLTldKiIKCWRldm5vZGUJCQkiXmhkLioiCglkZXZub2RlCQkJIl5jY2lzcyFjWzAtOV1k
WzAtOV0qW3BbMC05XSpdIgoJZGV2aWNlIHsKCQl2ZW5kb3IJCQlJQk0tRVNYUwoJfQp9Cgpt
dWx0aXBhdGhzIHsKCW11bHRpcGF0aCB7CgkJd3dpZAkJCTM2MDBhMGI4MDAwMjk4NGFlMDAw
MDE3OWI0NmE2ODdmYgoJCWFsaWFzCQkJd3d3Cgl9CgltdWx0aXBhdGggewoJCXd3aWQJCQkz
NjAwYTBiODAwMDI5ODRhZTAwMDAxNzljNDZhNjg4NDMKCQlhbGlhcwkJCW15c3FsCgl9Cn0K
CmRldmljZXMgewoJZGV2aWNlIHsKCQl2ZW5kb3IJCQlER0MKCQlwcm9kdWN0CQkJUkFJRC4q
CgkJaGFyZHdhcmVfaGFuZGxlcgkiMSBlbWMiCgkJcHJpb19jYWxsb3V0CQkiL3NiaW4vbXBh
dGhfcHJpb19lbWMgL2Rldi8lbiIKCQlwYXRoX2NoZWNrZXIJCWVtY19jbGFyaWlvbgoJCXBh
dGhfZ3JvdXBpbmdfcG9saWN5CWdyb3VwX2J5X3ByaW8KCQlmYWlsYmFjawkJaW1tZWRpYXRl
CgkJbm9fcGF0aF9yZXRyeQkJcXVldWUKCX0KCWRldmljZSB7CgkJdmVuZG9yCQkJU1VOCgkJ
cHJvZHVjdAkJCUNTTTIwMF9SCgkJaGFyZHdhcmVfaGFuZGxlcgkiMSByZGFjIgoJCXByaW9f
Y2FsbG91dAkJIi91c3IvbG9jYWwvc2Jpbi9tcGF0aF9wcmlvX3JkYWMgL2Rldi8lbiIKCQlw
YXRoX2NoZWNrZXIJCXR1cgoJCXBhdGhfZ3JvdXBpbmdfcG9saWN5CWdyb3VwX2J5X3Nlcmlh
bAoJCWZhaWxiYWNrCQlpbW1lZGlhdGUKCQlub19wYXRoX3JldHJ5CQlxdWV1ZQoJfQp9Cg==
--------------010406010507040709040802
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------010406010507040709040802--
