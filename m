From: Alasdair G Kergon <agk@redhat.com>
Subject: devmap_name replacement
Date: Tue, 29 Mar 2005 20:29:28 +0100
Message-ID: <20050329192928.GD19749@agk.surrey.redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

No need for devmap_name as of device-mapper 1.01.01:
  dmsetup -C --noheadings -o name -j major -m minor info

Or if you invoke dmsetup as devmap_name (e.g. symlink)
it'll accept the devmap_name syntax:
  devmap_name major minor
  devmap_name major:minor

Alasdair
-- 
agk@redhat.com
