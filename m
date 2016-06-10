From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: multipath-tools: pg_init_retries not documented
Date: Fri, 10 Jun 2016 15:36:28 +0200
Message-ID: <1be7fe2e-8343-c8f4-d56b-a7a057b17468@gmail.com>
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
To: Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

pg_init_retries(features) is not documented anywhere in multipath-tools.

Only the kernel has some hints:
drivers/md/dm-mpath.c:  unsigned pg_init_retries;       /* Number of times to retry pg_init */
drivers/md/dm-mpath.c:          {1, 50, "pg_init_retries must be between 1 and 50"},
