From: Oren Held <oren@held.org.il>
Subject: feature="1 queue_if_no_path" vs. no_path_retry=queue
Date: Sat, 17 Sep 2011 01:47:37 +0300
Message-ID: <20110916224737.GB31898@orenhe-laptop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

According to all docs I've read, and some code, the following settings seem to have the same effect:
1. Setting features = "1 queue_if_no_path"
2. Setting no_path_retry = "queue"

Now that's confusing, especially when having conflicting configuration, e.g., from hwtable.c:
                /* IBM DS4100 */
                .vendor        = "IBM",
                .product       = "1724",
                .features      = "1 queue_if_no_path",
                .no_path_retry = 300,

It's not clear enough what would be the resulting behavior of this configuration.

Did I get it right? Is there a reason for keeping the features = "1 queue_if_no_path" option available in multipath-tools?

Thanks

Regards

- Oren
