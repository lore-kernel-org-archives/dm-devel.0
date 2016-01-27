From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: dm-multipath low performance with blk-mq
Date: Wed, 27 Jan 2016 13:10:20 +0200
Message-ID: <56A8A59C.3000708@dev.mellanox.co.il>
References: <569E11EA.8000305@dev.mellanox.co.il>
	<20160119224512.GA10515@redhat.com> <20160125214016.GA10060@redhat.com>
	<20160126160324.GA24665@redhat.com>
	<20160126164437.GB15979@infradead.org>
	<20160127020932.GA26919@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160127020932.GA26919@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: "keith.busch@intel.com" <keith.busch@intel.com>, Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: dm-devel.ids


>> Don't think I have time at the moment, sorry..
>
> No problem, I pulled the latest DM changes ontop of 'nvme-loop.2', see:
> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=devel
>
> I was able to use nvme-loop like was documented here:
> http://git.infradead.org/users/hch/block.git/commit/47d8d5b1db270463b5bd7b6a68cd89bd8762840d
>
> But I'm not too sure how Sagi used the resulting nvme device with
> multipath.. maybe he just manually pushed down a DM multipath table?
> And only used the single /dev/nvme0n1 device?  Sagi?

Hi Mike, sorry for the late response, I'm kinda caught up with other stuff.

So I think you are missing the a patch to support multipath that didn't
exist back when Christoph submitted the patchset.

It's a temp hack, and I don't have time to even check that it applies
correctly on nvme-loop.2, but here it is:

--
diff --git a/drivers/nvme/target/admin-cmd.c 
b/drivers/nvme/target/admin-cmd.c
index 0931e91..532234b 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -180,7 +180,8 @@ static void nvmet_execute_identify_ns(struct 
nvmet_req *req)
          */
         id->nmic = (1 << 0);

-       /* XXX: provide a nguid value! */
+       /* XXX: provide a real nguid value! */
+       memcpy(&id->nguid, &ns->nguid, sizeof(uuid_le));

         id->lbaf[0].ds = ns->blksize_shift;

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index e2a8893..a99343a 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -145,6 +145,9 @@ struct nvmet_ns *nvmet_ns_alloc(struct nvmet_subsys 
*subsys, u32 nsid)
         ns->nsid = nsid;
         ns->subsys = subsys;

+       /* XXX: Hacking nguids with uuid  */
+       uuid_le_gen(&ns->nguid);
+
         return ns;

  free_ns:
@@ -436,6 +439,7 @@ struct nvmet_subsys *nvmet_subsys_alloc(const char 
*subsys_name)
         if (!subsys)
                 return NULL;

+       subsys->ver = NVME_VS(1, 2);
         subsys->subsys_name = kstrndup(subsys_name, NVMF_NQN_SIZE,
                         GFP_KERNEL);
         if (IS_ERR(subsys->subsys_name)) {
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 111aa5e..8f68c5f 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -19,6 +19,7 @@ struct nvmet_ns {
         u32                     nsid;
         u32                     blksize_shift;
         loff_t                  size;
+       uuid_le                 nguid;

         struct nvmet_subsys     *subsys;
         const char              *device_path;
--
