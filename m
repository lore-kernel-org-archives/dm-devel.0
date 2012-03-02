From: George Shuklin <george.shuklin@gmail.com>
Subject: readonly snapshots of LVM on same machine
Date: Fri, 02 Mar 2012 06:11:52 +0400
Message-ID: <4F502C68.7000307@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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

Good day.

If I attach a readonly snapshot of same disk as system disk, I'm getting 
message of duplicate ID (obvious, huh).  But snapshot is in readonly, so 
there is no way to rename it or change ID. Changing ID of system LVM is 
not really good idea.

Is any way to get filesystem from snapshoted LVM? Snapshots created by 
external storage system.

Thanks.
