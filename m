From: Nauman Rafique <nauman@google.com>
Subject: Re: [PATCH 15/20] io-controller: map async requests to
	appropriate cgroup
Date: Thu, 28 May 2009 11:04:46 -0700
Message-ID: <e98e18940905281104t4099575bn6a20725c919061ba@mail.gmail.com>
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com>
	<1243377729-2176-16-git-send-email-vgoyal@redhat.com>
	<20090528.182740.193697101.ryov@valinux.co.jp>
	<20090528165710.GB4335@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090528165710.GB4335@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, jbaron@redhat.com
List-Id: dm-devel.ids

On Thu, May 28, 2009 at 9:57 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, May 28, 2009 at 06:27:40PM +0900, Ryo Tsuruta wrote:
>> Hi Vivek,
>>
>> > +#ifdef CONFIG_TRACK_ASYNC_CONTEXT
>> > + =A0 if (elv_bio_sync(bio)) {
>> > + =A0 =A0 =A0 =A0 =A0 /* sync io. Determine cgroup from submitting t=
ask context. */
>> > + =A0 =A0 =A0 =A0 =A0 cgroup =3D task_cgroup(current, io_subsys_id);
>> > + =A0 =A0 =A0 =A0 =A0 return cgroup;
>> > + =A0 }
>> > +
>> > + =A0 /* Async io. Determine cgroup from with cgroup id stored in pa=
ge */
>> > + =A0 bio_cgroup_id =3D get_blkio_cgroup_id(bio);
>> > +
>> > + =A0 if (!bio_cgroup_id)
>> > + =A0 =A0 =A0 =A0 =A0 return NULL;
>> > +
>> > + =A0 cgroup =3D blkio_cgroup_lookup(bio_cgroup_id);
>> > +#else
>> > + =A0 cgroup =3D task_cgroup(current, io_subsys_id);
>> > +#endif
>> > + =A0 return cgroup;
>> > +}
>>
>> There is a case where a kernel thread (such as device-mapper drivers)
>> submits a sync IO instead of a task which originates the IO. I think
>> you should always use get_blkio_cgroup_id() to determine cgroup.
>>
>
> Hi Ryo,
>
> Ok. Can you give some examples of drivers which are submitting reads in
> different context al-together. You mentioned in the past that dm-crypt
> looks like the one. How does current CFQ takes care of that. So if a
> BE prio 7 or an RT prio 0, task is submitting a READ, CFQ will not know=
 it
> and it will put that READ in the queue of the READ submitting device
> mapper thread (may be BE prio 3 or 4)?
>
> Always determining the cgroup from bio, will make things slower at the
> same time complicated from the CFQ point of view. Right now cfq creates
> and caches the queue pointer in the io context of the bio submitting ta=
sk
> and assumes sync requests are coming from that task/io context. Current=
ly
> there can only be one sync queue associated with one context. So if a s=
ingle
> thread is submitting reads (may be a worker thread) on behalf of other
> processes, then we loose the io context information. In fact currently =
we
> don't even carry ioprio and io class information in bio.
>
> So looks like we need to carry task io context information also in bio
> to be able to associate the bio to right queue at CFQ level. This makes
> it bit more complicated. For the time being I will keep it in my TODO
> list and handle it once other more severe problems have been taken care
> of.

From what I remember, Fernando pointed out the same problem in LFS'09
(device mapper drivers submitting sync bio) for his motivation to
track io_context in bio. Fernando, what is the state the patch you
were working on?

>
> Thanks
> Vivek
>
