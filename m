From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [BUG REPORT] multipath-tools: -EIO even if no_path_retry
	is set
Date: Tue, 23 Jun 2009 11:55:44 +0900
Message-ID: <4A404430.4050103@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

I found a bug below in multipath-tools.
I don't have a patch but just report it for now.

Problem
-------
Application receives -EIO even if 'no_path_retry = queue' is set,
when all paths are down and deleted nearly simultaneously.


Why does it happen?
-------------------
When 'no_path_retry = queue' is set in multipath.conf,
multipathd will do the following on table (re)load:
  1. load the table *without* 'queue_if_no_path'
  2. resume the table
  3. send a message to the dm device to set 'queue_if_no_path'

So there is a small window inbetween the step 2 and step 3 where
failed I/O is not queued.


How should it be fixed?
-----------------------
If 'no_path_retry' is set, multipathd puts 'queue_if_no_path'
in 'features' field of the table which is loaded.


Workaround
----------
Use 'features = "1 queue_if_no_path"' together with 'no_path_retry'
in multipath.conf.

Thanks,
Kiyoshi Ueda
