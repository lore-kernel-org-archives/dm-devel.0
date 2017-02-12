From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: multipath-tools: Standardization of no_path_retry
Date: Sun, 12 Feb 2017 23:41:06 +0100
Message-ID: <8f166de2-104a-61ee-afc4-d667a39c3719@gmail.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>, Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

There are plenty of arbitrary values:

      1                 .no_path_retry = 5,
      1                 .no_path_retry = 6,
      3                 .no_path_retry = 10,
      8                 .no_path_retry = 12,
      2                 .no_path_retry = 15,
      6                 .no_path_retry = 18,
      1                 .no_path_retry = 24,
     37                 .no_path_retry = 30,
      4                 .no_path_retry = (300 / DEFAULT_CHECKINT),


     19                 .no_path_retry = NO_PATH_RETRY_QUEUE,
     15       (Default) .no_path_retry = NO_PATH_RETRY_UNDEF,



Any thoughts about this?
