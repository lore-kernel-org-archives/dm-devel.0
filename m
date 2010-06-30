From: "Riches Jr, RobertX M" <robertx.m.riches.jr@intel.com>
Subject: Re: Is there a way to see updated contents of a
	DM	target's underlying device while the DM target is in use?
Date: Wed, 30 Jun 2010 16:53:23 -0700
Message-ID: <4BD43A85686FC34D819098DB1C3999D99E419AA2@orsmsx502.amr.corp.intel.com>
References: <4BD43A85686FC34D819098DB1C3999D99E4199BA@orsmsx502.amr.corp.intel.com>
	<20100630230828.GX23989@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_4BD43A85686FC34D819098DB1C3999D99E419AA2orsmsx502amrcor_"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100630230828.GX23989@agk-dp.fab.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: "Dm-Devel Mailing List Send-To Address (dm-devel@redhat.com)" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--_002_4BD43A85686FC34D819098DB1C3999D99E419AA2orsmsx502amrcor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Thank you for the wise council to carefully check my code.  I certainly int=
end to do that.

However, I am able to reproduce the symptom using the standard dm-linear mo=
dule supplied with the x86_64 kernel that comes with Ubuntu Karmic.  With t=
he attached script, the first 'od' on /dev/vg1/lv1, done before 'dmsetup re=
move', shows the first part of the file contains 0x00.  A second 'od' after=
 'dmsetup remove' shows the file contains random data.

I didn't see any queues or caches in dm-linear that would need to be flushe=
d.

Any other suggestions?

Thanks,

Robert Riches
Azad Consultant at Intel
=20
-----Original Message-----
From: Alasdair G Kergon [mailto:agk@redhat.com]=20
Sent: Wednesday, June 30, 2010 4:08 PM
To: Riches Jr, RobertX M
Cc: Dm-Devel Mailing List Send-To Address (dm-devel@redhat.com)
Subject: Re: [dm-devel] Is there a way to see updated contents of a DM targ=
et's underlying device while the DM target is in use?

Sounds like a coding problem you need to debug...check your device stack - =
and the
code you are using to look for the change - carefully, check where you are
queueing/flushing/caching etc.

Alasdair


--_002_4BD43A85686FC34D819098DB1C3999D99E419AA2orsmsx502amrcor_
Content-Type: application/octet-stream; name="test02linear"
Content-Description: test02linear
Content-Disposition: attachment; filename="test02linear"; size=1013;
	creation-date="Wed, 30 Jun 2010 16:50:52 GMT";
	modification-date="Wed, 30 Jun 2010 16:50:52 GMT"
Content-Transfer-Encoding: base64

IyEvYmluL2NzaCAtZgoKIyBDLXNoZWxsIHNjcmlwdCB0byBydW4gcGFydCBBIG9mIHRlc3QgMDIg
YnV0IHVzaW5nIHRoZSBfTElORUFSXyB0YXJnZXQuCgplY2hvICdjcmVhdGluZyBuZXcgcHYgZmls
ZScKZGQgaWY9L2Rldi96ZXJvIG9mPWRldjAxIGJzPTUxMiBjb3VudD0yMTA1MzQ0CmVjaG8gJycK
CmVjaG8gJ3NldHRpbmcgdXAgbHYnCmxvc2V0dXAgL2Rldi9sb29wMCBkZXYwMQpwdmNyZWF0ZSAv
ZGV2L2xvb3AwCnZnY3JlYXRlIHZnMSAvZGV2L2xvb3AwCmx2Y3JlYXRlIC1MIDEwMjRNIC1uIGx2
MSB2ZzEKCmVjaG8gJ3NldHRpbmcgdXAgbGluZWFyIG1hcHBpbmcnCmRtc2V0dXAgY3JlYXRlIGZy
ZWQwMSAtLXRhYmxlICcwIDIwOTcxNTIgbGluZWFyIC9kZXYvdmcxL2x2MSAwJwoKZWNobyAnd3Jp
dGluZyB0aGUgd2hvbGUgdGhpbmcnCnNsZWVwIDMKZGQgaWY9L2Rldi91cmFuZG9tIG9mPS9kZXYv
bWFwcGVyL2ZyZWQwMSBicz04MTkyCmVjaG8gJycKCmVjaG8gJ21ha2luZyBhIGNvcHknCnNsZWVw
IDMKY3AgLWkgL2Rldi92ZzEvbHYxIHp6LmZpbGUKZWNobyAnJwoKZWNobyAnZG9pbmcgYSBmaXJz
dCBkaWZmJwpzbGVlcCAzCmRpZmYgL2Rldi92ZzEvbHYxIHp6LmZpbGUKZWNobyBmaXJzdCBkaWZm
IHN0YXR1cyB3YXMgJHN0YXR1cwplY2hvICcnCgplY2hvICdzaG93aW5nIHRoZSBmaXJzdCBjb250
ZW50cycKb2QgLUEgeCAteGMgL2Rldi92ZzEvbHYxIHwgaGVhZAplY2hvICcnCgplY2hvICdyZW1v
dmluZyB0aGUgbGluZWFyIG1hcHBpbmcgc28gdGhlIGNoYW5nZXMgY2FuIGJlIHNlZW4nCnNsZWVw
IDMKZG1zZXR1cCByZW1vdmUgZnJlZDAxCmVjaG8gJycKCmVjaG8gJ3Nob3dpbmcgdGhlIHNlY29u
ZCBjb250ZW50cycKb2QgLUEgeCAteGMgL2Rldi92ZzEvbHYxIHwgaGVhZAplY2hvICcnCgplY2hv
ICdkb2luZyBhIHNlY29uZCBkaWZmJwpzbGVlcCAzCmRpZmYgL2Rldi92ZzEvbHYxIHp6LmZpbGUK
ZWNobyBzZWNvbmQgZGlmZiBzdGF0dXMgd2FzICRzdGF0dXMKZWNobyAnJwo=

--_002_4BD43A85686FC34D819098DB1C3999D99E419AA2orsmsx502amrcor_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--_002_4BD43A85686FC34D819098DB1C3999D99E419AA2orsmsx502amrcor_--
