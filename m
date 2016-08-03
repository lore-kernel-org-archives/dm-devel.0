From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: change path_grouping_policy / some values are very
	confusing
Date: Wed, 3 Aug 2016 03:15:28 +0200
Message-ID: <2b180855-7731-6bc6-aefc-4189035b9f7d@gmail.com>
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
To: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>
List-Id: dm-devel.ids

Hi,

I need an advice, and a pair of answers:

Would a change in the default path_grouping_policy from "failover" to "multibus"
be accepted?

Are "0" / FAILBACK_UNDEF / -FAILBACK_MANUAL the same?

Are "0" / NO_PATH_RETRY_UNDEF / NO_PATH_RETRY_FAIL the same?

The man page is a bit sparse about these options.

Thank you.
