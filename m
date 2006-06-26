From: akpm@osdl.org
Subject: [patch 012/215] drivers: use list_move()
Date: Mon, 26 Jun 2006 00:24:41 -0700
Message-ID: <200606260724.k5Q7Of2V029559@shell0.pdx.osdl.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: torvalds@osdl.org
Cc: akpm@osdl.org, mita@miraclelinux.com, matthew@wil.cx, greg@kroah.com, starvik@axis.com, dm-devel@redhat.com, kraxel@bytesex.org, bcollins@debian.org, linux-driver@qlogic.com, fpavlic@de.ibm.com, rolandd@cisco.com, paulus@samba.org, minyard@mvista.com
List-Id: dm-devel.ids


From: Akinobu Mita <mita@miraclelinux.com>

This patch converts the combination of list_del(A) and list_add(A, B) to
list_move(A, B) under drivers/.

Acked-by: Corey Minyard <minyard@mvista.com>
Cc: Ben Collins <bcollins@debian.org>
Acked-by: Roland Dreier <rolandd@cisco.com>
Cc: Alasdair Kergon <dm-devel@redhat.com>
Cc: Gerd Knorr <kraxel@bytesex.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frank Pavlic <fpavlic@de.ibm.com>
Acked-by: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Vasquez <linux-driver@qlogic.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Signed-off-by: Akinobu Mita <mita@miraclelinux.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/ipmi/ipmi_msghandler.c            |    7 +----
 drivers/ieee1394/eth1394.c                     |    3 --
 drivers/ieee1394/raw1394.c                     |    3 --
 drivers/infiniband/core/mad.c                  |    9 ++-----
 drivers/infiniband/core/mad_rmpp.c             |    3 --
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    6 +---
 drivers/md/dm-raid1.c                          |    6 +---
 drivers/media/video/cx88/cx88-video.c          |    6 +---
 drivers/net/ppp_generic.c                      |    3 --
 drivers/s390/net/lcs.c                         |    7 ++---
 drivers/scsi/ncr53c8xx.c                       |    3 --
 drivers/scsi/qla2xxx/qla_init.c                |    3 --
 drivers/usb/host/hc_crisv10.c                  |    3 --
 drivers/usb/serial/whiteheat.c                 |   19 +++++----------
 14 files changed, 28 insertions(+), 53 deletions(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~drivers-use-list_move drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~drivers-use-list_move
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -936,11 +936,8 @@ int ipmi_set_gets_events(ipmi_user_t use
 
 	if (val) {
 		/* Deliver any queued events. */
-		list_for_each_entry_safe(msg, msg2, &intf->waiting_events,
-					 link) {
-			list_del(&msg->link);
-			list_add_tail(&msg->link, &msgs);
-		}
+		list_for_each_entry_safe(msg, msg2, &intf->waiting_events, link)
+			list_move_tail(&msg->link, &msgs);
 		intf->waiting_events_count = 0;
 	}
 
diff -puN drivers/ieee1394/eth1394.c~drivers-use-list_move drivers/ieee1394/eth1394.c
--- a/drivers/ieee1394/eth1394.c~drivers-use-list_move
+++ a/drivers/ieee1394/eth1394.c
@@ -1074,8 +1074,7 @@ static inline int update_partial_datagra
 
 	/* Move list entry to beginnig of list so that oldest partial
 	 * datagrams percolate to the end of the list */
-	list_del(lh);
-	list_add(lh, pdgl);
+	list_move(lh, pdgl);
 
 	return 0;
 }
diff -puN drivers/ieee1394/raw1394.c~drivers-use-list_move drivers/ieee1394/raw1394.c
--- a/drivers/ieee1394/raw1394.c~drivers-use-list_move
+++ a/drivers/ieee1394/raw1394.c
@@ -132,8 +132,7 @@ static void free_pending_request(struct 
 static void __queue_complete_req(struct pending_request *req)
 {
 	struct file_info *fi = req->file_info;
-	list_del(&req->list);
-	list_add_tail(&req->list, &fi->req_complete);
+	list_move_tail(&req->list, &fi->req_complete);
 
 	up(&fi->complete_sem);
 	wake_up_interruptible(&fi->poll_wait_complete);
diff -puN drivers/infiniband/core/mad.c~drivers-use-list_move drivers/infiniband/core/mad.c
--- a/drivers/infiniband/core/mad.c~drivers-use-list_move
+++ a/drivers/infiniband/core/mad.c
@@ -1775,11 +1775,9 @@ ib_find_send_mad(struct ib_mad_agent_pri
 void ib_mark_mad_done(struct ib_mad_send_wr_private *mad_send_wr)
 {
 	mad_send_wr->timeout = 0;
-	if (mad_send_wr->refcount == 1) {
-		list_del(&mad_send_wr->agent_list);
-		list_add_tail(&mad_send_wr->agent_list,
+	if (mad_send_wr->refcount == 1)
+		list_move_tail(&mad_send_wr->agent_list,
 			      &mad_send_wr->mad_agent_priv->done_list);
-	}
 }
 
 static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
@@ -2098,8 +2096,7 @@ retry:
 		queued_send_wr = container_of(mad_list,
 					struct ib_mad_send_wr_private,
 					mad_list);
-		list_del(&mad_list->list);
-		list_add_tail(&mad_list->list, &send_queue->list);
+		list_move_tail(&mad_list->list, &send_queue->list);
 	}
 	spin_unlock_irqrestore(&send_queue->lock, flags);
 
diff -puN drivers/infiniband/core/mad_rmpp.c~drivers-use-list_move drivers/infiniband/core/mad_rmpp.c
--- a/drivers/infiniband/core/mad_rmpp.c~drivers-use-list_move
+++ a/drivers/infiniband/core/mad_rmpp.c
@@ -665,8 +665,7 @@ static void process_rmpp_ack(struct ib_m
 			goto out;
 
 		mad_send_wr->refcount++;
-		list_del(&mad_send_wr->agent_list);
-		list_add_tail(&mad_send_wr->agent_list,
+		list_move_tail(&mad_send_wr->agent_list,
 			      &mad_send_wr->mad_agent_priv->send_list);
 	}
 out:
diff -puN drivers/infiniband/ulp/ipoib/ipoib_multicast.c~drivers-use-list_move drivers/infiniband/ulp/ipoib/ipoib_multicast.c
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c~drivers-use-list_move
+++ a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -864,8 +864,7 @@ void ipoib_mcast_restart_task(void *dev_
 
 			if (mcast) {
 				/* Destroy the send only entry */
-				list_del(&mcast->list);
-				list_add_tail(&mcast->list, &remove_list);
+				list_move_tail(&mcast->list, &remove_list);
 
 				rb_replace_node(&mcast->rb_node,
 						&nmcast->rb_node,
@@ -890,8 +889,7 @@ void ipoib_mcast_restart_task(void *dev_
 			rb_erase(&mcast->rb_node, &priv->multicast_tree);
 
 			/* Move to the remove list */
-			list_del(&mcast->list);
-			list_add_tail(&mcast->list, &remove_list);
+			list_move_tail(&mcast->list, &remove_list);
 		}
 	}
 
diff -puN drivers/md/dm-raid1.c~drivers-use-list_move drivers/md/dm-raid1.c
--- a/drivers/md/dm-raid1.c~drivers-use-list_move
+++ a/drivers/md/dm-raid1.c
@@ -458,11 +458,9 @@ static int __rh_recovery_prepare(struct 
 	/* Already quiesced ? */
 	if (atomic_read(&reg->pending))
 		list_del_init(&reg->list);
+	else
+		list_move(&reg->list, &rh->quiesced_regions);
 
-	else {
-		list_del_init(&reg->list);
-		list_add(&reg->list, &rh->quiesced_regions);
-	}
 	spin_unlock_irq(&rh->region_lock);
 
 	return 1;
diff -puN drivers/media/video/cx88/cx88-video.c~drivers-use-list_move drivers/media/video/cx88/cx88-video.c
--- a/drivers/media/video/cx88/cx88-video.c~drivers-use-list_move
+++ a/drivers/media/video/cx88/cx88-video.c
@@ -494,8 +494,7 @@ static int restart_video_queue(struct cx
 			return 0;
 		buf = list_entry(q->queued.next, struct cx88_buffer, vb.queue);
 		if (NULL == prev) {
-			list_del(&buf->vb.queue);
-			list_add_tail(&buf->vb.queue,&q->active);
+			list_move_tail(&buf->vb.queue, &q->active);
 			start_video_dma(dev, q, buf);
 			buf->vb.state = STATE_ACTIVE;
 			buf->count    = q->count++;
@@ -506,8 +505,7 @@ static int restart_video_queue(struct cx
 		} else if (prev->vb.width  == buf->vb.width  &&
 			   prev->vb.height == buf->vb.height &&
 			   prev->fmt       == buf->fmt) {
-			list_del(&buf->vb.queue);
-			list_add_tail(&buf->vb.queue,&q->active);
+			list_move_tail(&buf->vb.queue, &q->active);
 			buf->vb.state = STATE_ACTIVE;
 			buf->count    = q->count++;
 			prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
diff -puN drivers/net/ppp_generic.c~drivers-use-list_move drivers/net/ppp_generic.c
--- a/drivers/net/ppp_generic.c~drivers-use-list_move
+++ a/drivers/net/ppp_generic.c
@@ -2578,8 +2578,7 @@ ppp_find_channel(int unit)
 
 	list_for_each_entry(pch, &new_channels, list) {
 		if (pch->file.index == unit) {
-			list_del(&pch->list);
-			list_add(&pch->list, &all_channels);
+			list_move(&pch->list, &all_channels);
 			return pch;
 		}
 	}
diff -puN drivers/s390/net/lcs.c~drivers-use-list_move drivers/s390/net/lcs.c
--- a/drivers/s390/net/lcs.c~drivers-use-list_move
+++ a/drivers/s390/net/lcs.c
@@ -1140,10 +1140,9 @@ list_modified:
 		}
 	}
 	/* re-insert all entries from the failed_list into ipm_list */
-	list_for_each_entry_safe(ipm, tmp, &failed_list, list) {
-		list_del_init(&ipm->list);
-		list_add_tail(&ipm->list, &card->ipm_list);
-	}
+	list_for_each_entry_safe(ipm, tmp, &failed_list, list)
+		list_move_tail(&ipm->list, &card->ipm_list);
+
 	spin_unlock_irqrestore(&card->ipm_lock, flags);
 }
 
diff -puN drivers/scsi/ncr53c8xx.c~drivers-use-list_move drivers/scsi/ncr53c8xx.c
--- a/drivers/scsi/ncr53c8xx.c~drivers-use-list_move
+++ a/drivers/scsi/ncr53c8xx.c
@@ -5118,8 +5118,7 @@ static void ncr_ccb_skipped(struct ncb *
 		cp->host_status &= ~HS_SKIPMASK;
 		cp->start.schedule.l_paddr = 
 			cpu_to_scr(NCB_SCRIPT_PHYS (np, select));
-		list_del(&cp->link_ccbq);
-		list_add_tail(&cp->link_ccbq, &lp->skip_ccbq);
+		list_move_tail(&cp->link_ccbq, &lp->skip_ccbq);
 		if (cp->queued) {
 			--lp->queuedccbs;
 		}
diff -puN drivers/scsi/qla2xxx/qla_init.c~drivers-use-list_move drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c~drivers-use-list_move
+++ a/drivers/scsi/qla2xxx/qla_init.c
@@ -2258,8 +2258,7 @@ qla2x00_configure_fabric(scsi_qla_host_t
 			}
 
 			/* Remove device from the new list and add it to DB */
-			list_del(&fcport->list);
-			list_add_tail(&fcport->list, &ha->fcports);
+			list_move_tail(&fcport->list, &ha->fcports);
 
 			/* Login and update database */
 			qla2x00_fabric_dev_login(ha, fcport, &next_loopid);
diff -puN drivers/usb/host/hc_crisv10.c~drivers-use-list_move drivers/usb/host/hc_crisv10.c
--- a/drivers/usb/host/hc_crisv10.c~drivers-use-list_move
+++ a/drivers/usb/host/hc_crisv10.c
@@ -411,8 +411,7 @@ static inline void urb_list_move_last(st
 	urb_entry_t *urb_entry = __urb_list_entry(urb, epid);
 	assert(urb_entry);
 
-	list_del(&urb_entry->list);
-	list_add_tail(&urb_entry->list, &urb_list[epid]);
+	list_move_tail(&urb_entry->list, &urb_list[epid]);
 }
 
 /* Get the next urb in the list. */
diff -puN drivers/usb/serial/whiteheat.c~drivers-use-list_move drivers/usb/serial/whiteheat.c
--- a/drivers/usb/serial/whiteheat.c~drivers-use-list_move
+++ a/drivers/usb/serial/whiteheat.c
@@ -686,19 +686,16 @@ static void whiteheat_close(struct usb_s
 		wrap = list_entry(tmp, struct whiteheat_urb_wrap, list);
 		urb = wrap->urb;
 		usb_kill_urb(urb);
-		list_del(tmp);
-		list_add(tmp, &info->rx_urbs_free);
-	}
-	list_for_each_safe(tmp, tmp2, &info->rx_urb_q) {
-		list_del(tmp);
-		list_add(tmp, &info->rx_urbs_free);
+		list_move(tmp, &info->rx_urbs_free);
 	}
+	list_for_each_safe(tmp, tmp2, &info->rx_urb_q)
+		list_move(tmp, &info->rx_urbs_free);
+
 	list_for_each_safe(tmp, tmp2, &info->tx_urbs_submitted) {
 		wrap = list_entry(tmp, struct whiteheat_urb_wrap, list);
 		urb = wrap->urb;
 		usb_kill_urb(urb);
-		list_del(tmp);
-		list_add(tmp, &info->tx_urbs_free);
+		list_move(tmp, &info->tx_urbs_free);
 	}
 	spin_unlock_irqrestore(&info->lock, flags);
 
@@ -1080,8 +1077,7 @@ static void whiteheat_write_callback(str
 		err("%s - Not my urb!", __FUNCTION__);
 		return;
 	}
-	list_del(&wrap->list);
-	list_add(&wrap->list, &info->tx_urbs_free);
+	list_move(&wrap->list, &info->tx_urbs_free);
 	spin_unlock(&info->lock);
 
 	if (urb->status) {
@@ -1371,8 +1367,7 @@ static int start_port_read(struct usb_se
 				wrap = list_entry(tmp, struct whiteheat_urb_wrap, list);
 				urb = wrap->urb;
 				usb_kill_urb(urb);
-				list_del(tmp);
-				list_add(tmp, &info->rx_urbs_free);
+				list_move(tmp, &info->rx_urbs_free);
 			}
 			break;
 		}
_
