From: karl shaul <shaulk@013.net>
Subject: Manualy creating device files in /dev for lvm.
Date: Sat, 25 Feb 2006 22:34:02 +0200
Message-ID: <172575a33a9c.4400db5a@default.domain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-language: en
Content-disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

  Can I manualy  create device files (in /dev) for lvm? If so, where can I learn which
files are needed?
  I want to have a simple lvm configuration for a desktop: just one hard disk with a 
few LVs. I believe I can apriori determine the names involved, uuid, etc. Can I mknod
the device files so that no such files will be created dynamically?
  Should I try on linux-lvm@reddhat.com?
