From: saeed bishara <saeed.bishara@gmail.com>
Subject: how to bypass exclusive access
Date: Sun, 15 May 2011 17:37:30 +0300
Message-ID: <BANLkTinHwWjVWHgE+Z6gdcT9cd0=jYBh1g@mail.gmail.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,
   I'm trying to do linear mapping for part of a disk that used also
as boot device, but the dmsetup create fails as this disk is used.
  is there any way to workaround that?
  the partition that I'm using as rootfs and the part that will be
used as linear device don't overlap, does that mean there will be no
risk for data corruption if I modified the dm code to disable the
exclusive access?

saeed
