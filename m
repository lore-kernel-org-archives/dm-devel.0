From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [RFC] IO scheduler based IO controller V4
Date: Wed, 10 Jun 2009 09:05:32 +0800
Message-ID: <4A2F06DC.8040600@cn.fujitsu.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com> <4A2DE381.6090205@cn.fujitsu.com> <20090609135256.GA13476@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755626AbZFJBHW@vger.kernel.org>
In-Reply-To: <20090609135256.GA13476@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
> On Tue, Jun 09, 2009 at 12:22:25PM +0800, Gui Jianfeng wrote:
>> Vivek Goyal wrote:
>>> Hi All,
>>>
>>> Here is the V4 of the IO controller patches generated on top of 2.6=
=2E30-rc8.
>>>
>> Hi Vivek,
>>
>> I can't apply the patchset.
>>
>> [root@localhost linux-2.6.30-rc8-Vivek-V4]# git-am ../V4/1.eml
>> Applying io-controller: Documentation
>> [root@localhost linux-2.6.30-rc8-Vivek-V4]# git-am ../V4/2.eml
>> Applying io-controller: Common flat fair queuing code in elevaotor l=
ayer
>> error: patch failed: block/Makefile:15
>> error: block/Makefile: patch does not apply
>> Patch failed at 0001.
>> When you have resolved this problem run "git-am --resolved".
>> If you would prefer to skip this patch, instead run "git-am --skip".
>=20
> Hi Gui,
>=20
> This is strange. It seems to be applying cleanly for me. Can you plea=
se
> recheck your setup and also see why it is failing. In block/Makefile,
> there is one line change and recently no change has taken to that fil=
e
> in git.

Hi Vivek=EF=BC=8C

I guess this patchset is still on top of 2.6.30-rc7 rather than rc8...
I can apply it against rc7 cleanly.


--=20
Regards
Gui Jianfeng
