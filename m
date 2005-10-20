From: =?iso-8859-1?B?Q2FybG9zIFBl824gQ29zdGE=?= <carlospeon@hotmail.com>
Subject: devfs_mk_dev: could not append to parent
Date: Thu, 20 Oct 2005 18:53:00 +0200
Message-ID: <BAY106-F235FDBCABC8DF8EECA83E3DB730@phx.gbl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello:

I get this messages at system startup:

device-mapper: 4.4.0-ioctl (2005-01-12) initialised: dm-devel@redhat.com
devfs_mk_dev: could not append to parent for md/0
md: md0 stopped.
md: bind<sda1>
raid1: raid set md0 active with 1 out of 1 mirrors
devfs_mk_dev: could not append to parent for md/1
devfs_mk_dev: could not append to parent for md/2
devfs_mk_dev: could not append to parent for md/3
devfs_mk_dev: could not append to parent for md/4
devfs_mk_dev: could not append to parent for md/5
devfs_mk_dev: could not append to parent for md/6
...
...
devfs_mk_dev: could not append to parent for md/254
devfs_mk_dev: could not append to parent for md/255

The systems works normaly, but is everything right?

I'm using dm and LVM with kernel 2.6.12 (debian amd64)

Thanks.
