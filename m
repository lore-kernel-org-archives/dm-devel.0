From: "Meneghini, John" <John.Meneghini@netapp.com>
Subject: Re: nvme: restore use of blk_path_error() in
	nvme_complete_rq()
Date: Tue, 11 Aug 2020 12:54:48 +0000
Message-ID: <4EFA1979-A126-43F0-9F31-B4A80576E329@netapp.com>
References: <E3390A8E-D582-47BA-A085-21663D883365@netapp.com>
	<20200806184057.GA27858@redhat.com> <20200806191943.GA27868@redhat.com>
	<6B826235-C504-4621-B8F7-34475B200979@netapp.com>
	<20200807000755.GA28957@redhat.com>
	<510f5aff-0437-b1ce-f7ab-c812edbea880@grimberg.me>
	<20200807045015.GA29737@redhat.com>
	<fec745aa-0091-ee1f-cb0f-da9e18cf0aa2@grimberg.me>
	<842F6313-F3CC-46AC-A15A-A44E50C5BD18@netapp.com>
	<BE5FA5D8-508D-4D2B-9BCC-632CDC51186E@netapp.com>
	<20200810144834.GB19127@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200810144834.GB19127@redhat.com>
Content-Language: en-US
Content-ID: <48E885D5D98E7348AA33FE50715E497B@namprd06.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Christoph Hellwig <hch@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Ewan Milne <emilne@redhat.com>, Chao Leng <lengchao@huawei.com>, Busch <kbusch@kernel.org>, "Meneghini,
	John" <John.Meneghini@netapp.com>, Keith
List-Id: dm-devel.ids

On 8/10/20, 10:49 AM, "Mike Snitzer" <snitzer@redhat.com> wrote:

    I appreciate your insight about ACRE.  And that NVME_SC_CMD_INTERRUPTED
    is really just a preview for the kind of NVMe error handling advances to
    come.

    But, because I started harping about blk_path_error() I got you
    hyper-focused on it and that led to all your thinking about me wanting
    to somehow normalize both SCSI and NVMe.  Couldn't be further from my
    thinking.  I've always wanted Linux's NVMe driver to do whatever it
    needed to handle the evolution of NVMe.  I just really need it to do it
    in a way that: respects NVMe's spec for ANA, ACRE and the like in way
    that doesn't make NVMe error handling broken if native NVMe multipath
    isn't used.

Agreed Mike.

I just wanted be sure we are understanding the problem clearly.

    The good news is I still don't see a need to model NVMe error handling
    with BLK_STS et al.

Yes, I agree some alternative to modeling things around BLK_STS would be good... perhaps even required.

I'll admit my suggested solutions don't help much.

    But AFAICT the NVMe error handling needs some fixing/cleanup.  To be
    continued, with patches so we can collectively have a more productive
    discussion.

If someone can come up with a solution that allows nvme-core error handling to work freely with and without native nvme-multipathing, I'm all for it.  
But we also need a solution that any solution is future proof because more changes are coming.  

/John

    Thanks,
    Mike

    On Sat, Aug 08 2020 at  5:11pm -0400,
    Meneghini, John <John.Meneghini@netapp.com> wrote:

    > Having said all of this, I think one thing which could be done to help
    > support NVMe with DMP is to approximate any new NVMe error semantics
    > by adding new BLK_STS codes. Reusing or overloading existing BLK_STS
    > may not work well because everyone else already has a claim on those
    > semantics.  I would suggest adding new BLK_STS to the
    > nvme_error_status() routine.  I think this is the one place where NVMe
    > status to BLK_STS translation belongs, and changes can be made there
    > without impacting any of the NVMe error handling logic in nvme-core -
    > now that we've removed blk_path_error() from nvme_complete_rq().
    >
    > Another choice would be to simply disable ACRE.  This won't solve the
    > problem of changing NVMe error semantics with dm-multipath but it can
    > certainly simplify the problem. Maybe a patch that disables ACRE when
    > REQ_NVME_MPATH is clear.  Or you can always just turn the feature off
    > with the nvme-cli.  I'll be sure to keep an eye on the Host Behavior
    > Support feature at NVMexpress.org.  We created this new nvme feature
    > control mechanism to help with problems like this and I'll be sure to
    > watch out for new protocol features which could break compatibility
    > with dm-multipath in the future.
    >
    > /John
    >
    > On 8/8/20, 5:08 PM, "Meneghini, John" <John.Meneghini@netapp.com> wrote:
    >
    >     I'd like to up level this whole conversation for a minute by
    > talking about exactly what ACRE does.
    >
    >     The genesis of the changes discussed in this thread is NVMe
    > TP-4033 - Enhanced Command Retry.  You can find a copy of this TP
    > here:
    >
    >     http://nvmexpress.org/wp-content/uploads/NVM-Express-1.3-Ratified-TPs.zip
    >
    >     This technical proposal added a command retry delay feature which
    > is programmed by the controller. The controller advertises a set of 3
    > different timing delays though the Identify Controller data structure
    > CRDT{1-2} fields.  To make use of these delay fields a new CRD field
    > was added to the CQE Status Field.  This allows the NVMe controller to
    > specify exactly how long a command retry should be delayed, with 3
    > possible timers that it chooses and controls.  CRDTs can range from
    > 100 milliseconds to 6559 seconds.  Because this capability can have
    > such a radical effect on backwards compatibility a new NVMe Feature
    > Identifier was added (Host Behavior Support - Feature ID 16h) with an
    > Advanced Command Retry Enable (ACRE) bit.  This allows the host to
    > enable or disable the feature.
    >
    >     With this background there are a couple of misconceptions in this
    > thread which I'd like to address.
    >
    >     The first is: ACRE has nothing to do with the
    > NVME_SC_CMD_INTERRUPTED status.  Yes, this new error status was added
    > as a part of TP-4033 but the CRD field of the CQE status can be set by
    > the controller with *any* NVMe error status. As long as the DNR bit is
    > not set the Command Retry Delay can come into effect. This is how the
    > spec is written and this is exactly how it has been implemented in the
    > core nvme_complete_rq() function (after change 507fe46ac91276120). For
    > example, the controller can return NVME_SC_NS_NOT_READY with a CRDT of
    > 2 seconds.^  So CDRT needs to be supported with all error status if
    > the host is going to enable ACRE, and I think it's a big mistake to
    > get hung up over the NVME_SC_CMD_INTERRUPTED status translation. The
    > NVME_SC_CMD_INTERRUPTED status was only added to the spec to provide a
    > general purpose "busy" status, something that was missing from NVMe,
    > and focusing your solution on NVME_SC_CMD_INTERRUPTED, or any other
    > specific NVMe error status, is the wrong thing to do.  There is a much
    > larger change in error semantics going on with ACRE than just this
    > single error.
    >
    >     The second is:  All NVMe error status that do not have a Status
    > Code Type of 3h (Path Related Status) are subsystem scoped. This is a
    > topic that has gone through some debate on the linux-nvme mailing list
    > and at NVMexpress.org; and there have been some ECNs to the spec to
    > address this. There may be some exceptions to this rule because there
    > are always implementations out there that may not follow, and there
    > are bugs in the spec.  However, this is the intention of the NVMe spec
    > and it matters. This means that, in a multi-pathing environment,
    > retrying any command on a different path will not provide a different
    > result. Retries should all occur on the same controller - unless it is
    > a path related status.  This is how NVMe error semantics work and this
    > is a part of what was behind Keith's patch .
    >
    >     https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=35038bffa87da
    >
    >     Retrying NVME_SC_NS_NOT_READY or NVME_SC_CMD_INTERRUPTED on
    > another path is simply not the right thing to do, and returning
    > BLK_STS_TARGET after all command retries, with CRDT, have been
    > exhausted communicates the right thing to the upper layer. From the
    > perspective of nvme-multipathing Keith's patch was exactly the correct
    > thing to do.  I understand that this may have caused a backwards
    > compatibly problem with dm-multipath, and that's the only reason why
    > I've talked about backing it out.  However, ultimately, I think
    > nvme-core should return an error status like  BLK_STS_TARGET that
    > says, semantically - the IO has failed, no retry will work - because
    > this is what the NVMe error semantics are.
    >
    >     Taken together both of these facts about the NVMe protocol
    > semantics are what's behind my patch which removed blk_path_error()
    > from nvme_complete_rq()
    >
    >     https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=764e9332098c0e60251386a507fe46ac91276120
    >
    >     I understand that there is a goal to try and avoid having
    > different failure/recovery handling semantically in response to
    > different error status between nvme-multipath and dm-multipath, but
    > NVMe error semantics are truly different from SCSI error semantics,
    > and they are changing. The Linux host needs to enable and support
    > those changes unhampered by the past. With this goal in mind, removing
    > the blk_path_error() code from nvme-core was the right thing to do.
    > Hannes and I struggled with the patch to try and make it work with
    > blk_path_error() for weeks.  As pointed out in the thread below,
    > blk_path_error() is the SCSI multipathing logic and we can't use it in
    > nvme_complete_rq().  All it does is import all of the legacy problems
    > of dm-multipath, and of SCSI, into the nvme completion/multipath
    > logic.
    >
    >     At NVMexpress.org we consciously added the ACRE feature because
    > the SCSI protocol had no such capability.  This is something which has
    > plagued SCSI implementations for years,  and all kinds of tricks have
    > been played, in both the SCSI host stack and in SCSI target stack, to
    > deal with the problem. The goal of NVMe is to create a better block
    > storage protocol and ACRE is just one example of many places where the
    > industry is trying to do this.  There are plans to introduce more Host
    > Behavior Support features in the future.
    >
    >     In the end, we are consciously changing NVMe, both in the spec and
    > in its implementation, to make it different from SCSI. I think this is
    > what's at the bottom of the changes discussed in this thread, and this
    > is why so many people are so passionate about this.  We don't want to
    > turn NVMe into SCSI.  I know I don't want to.
    >
    >     /John
    >
    >     ^Note: (maybe a 2 second delay sounds unreasonable for a flash storage device but there implementors that that want to use NVMe with spinning disks... so the CDRT gives them exactly what they need).
    >
