From: Alasdair G Kergon <agk@redhat.com>
Subject: LVM2 / device-mapper packages
Date: Tue, 5 Apr 2005 22:50:21 +0100
Message-ID: <20050405215021.GK9049@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, linux-lvm@redhat.com
List-Id: dm-devel.ids

I've updated the stable pointers to point to the latest packages:

  LVM2: 2.01.09
  device-mapper: 1.01.01 

and I recommend updating to those packages.

Dependencies:
  Upgrade device-mapper to 1.01.something before upgrading
  lvm2 to 2.01.something - keep the middle component numbers (.01.)
  in step with each other.
 

I've only been applying bug fixes for some time now:
The next release will start incorporating new features again,
so expect a period of less-stable development-only releases.

Alasdair
-- 
agk@redhat.com
