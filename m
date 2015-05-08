From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: dm-snap-persistent: chunk_io doesn't call
 destroy_work_on_stack in 3.10.76
Date: Fri, 08 May 2015 16:38:24 +0900
Message-ID: <554C67F0.3070707@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

I am looking at 3.10.76 kernel and found that
chunk_io function of dm-snap-persistent doesn't call
destroy_work_on_stack to pair with INIT_WORK_ON_STACK.

        INIT_WORK_ONSTACK(&req.work, do_metadata);
        queue_work(ps->metadata_wq, &req.work);
        flush_workqueue(ps->metadata_wq);
        // I think you need it here
 
        return req.result;

Is it not buggy?

- Akira
