From: zhangdongmao <dmzhang@suse.com>
Subject: Re: [PATCH] convert dm_ulog_request data to little endian
Date: Thu, 21 Aug 2014 13:07:11 +0800
Message-ID: <53F57E7F.2090705@suse.com>
References: <1407459365-697-1-git-send-email-dmzhang@suse.com>
	<589E3349-24C0-4CBD-AA99-6F537BCDAAFB@redhat.com>
	<53F413A6.2000409@suse.com>
	<9FC3B4B3-9310-41FF-8E89-709A8790549E@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9FC3B4B3-9310-41FF-8E89-709A8790549E@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


> v5_endian_from_network() only gets called if it is needed.  I suspect there is a bug here, 'clog_request_to_network' should detect if big endian is being used and switch it to little endian.  In-coming communication must always be little endian.  I'm not sure which end the problem is on (I think the send side).  You could add some prints to detect the issue.
>
> lvm2/daemons/cmirrord/cluster.c:cluster_send() sets two version numbers - one is forced to be little endian via xlate64().  'clog_request_to_network()' is then called and compares the two version numbers.  If they are different, the machine is big endian and the contents must be converted.  If this is not happening, it is bad.  Then, *from_network() performs a similar action and test and then must xlate back to big endian.  If this is not happening, it is bad.  So, for big endian machines, ensure that v5_endian_*_network() is being called.  (For little endian, it should not be.)
>
>   brassow
hi,  brassow ,

       There might be a bug in v5_endian_to_network when sending packet.
       If the machine were big-endian,  v5_endian_to_network will 
convert request_type to little endian.
But in v5_data_endian_switch, it will check request_type again, and this 
check will failed because request_type is already converted
to little endian. So my solution to this is to delay xlate32 of 
u_rq->request_type.

      On the other hand, when receiving package in 
clog_request_from_network. I think the vp[0] will always be little endian.
we could use xlate64(vp[0]) == vp[0] to decide if the local node is 
little endian or not. if local node is little endian, we do nothing,
if the local node is big endian, we have to call v5_endian_from_network 
to convert little endian to big endian.

      But for now, I have not had a chance to test this patch on s390


here's the patch:

diff --git a/daemons/cmirrord/compat.c b/daemons/cmirrord/compat.c
index 3f7a9b5..c9cb803 100644
--- a/daemons/cmirrord/compat.c
+++ b/daemons/cmirrord/compat.c
@@ -126,13 +126,14 @@ static int v5_endian_to_network(struct 
clog_request *rq)

         u_rq->error = xlate32(u_rq->error);
         u_rq->seq = xlate32(u_rq->seq);
-       u_rq->request_type = xlate32(u_rq->request_type);
         u_rq->data_size = xlate64(u_rq->data_size);

         rq->originator = xlate32(rq->originator);

         v5_data_endian_switch(rq, 1);

+       rq->u_rq.request_type = xlate32(rq->u_rq.request_type);
+
         return size;
  }

@@ -187,7 +188,7 @@ int clog_request_from_network(void *data, size_t 
data_len)

         switch (version) {
         case 5: /* Upstream */
-               if (version == unconverted_version)
+               if (version == vp[0])
                         return 0;
                 break;
         case 4: /* RHEL 5.[45] */



Dongmao Zhang
