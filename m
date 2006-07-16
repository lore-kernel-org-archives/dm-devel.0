From: Paul Reilly <paul@astropaul.com>
Subject: dm ioctl cmd 9 failed: Cannot allocate memory
Date: Sat, 15 Jul 2006 21:08:06 -0700
Message-ID: <1153022886.44b9bba6ec583@mail.third-rock.net>
References: <mailman.12195.1153022224.1982.dm-devel@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <mailman.12195.1153022224.1982.dm-devel@redhat.com>
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


Hi,

I'm getting various lvm/devmapper errors when creating and removing
snapshots on debian Sarge.

  device-mapper ioctl cmd 9 failed: Cannot allocate memory
  Couldn't load device 'myvg-www2_snapshot'.
  Unable to deactivate logical volume "myvg-www2_snapshot"

I can now no longer make changes to LVM volumes, my processes
just hang and are un-killable.

I am using:

 lvm2                            2.01.04-5
 libdevmapper1.01                1.01.00-4
 kernel 2.6.10


Is this a known bug in my version of devmapper?

This appears to be the latest version of LVM and device-mapper
in debian Sarge. Does anyone know if there are updates to fix this
issue?

What is the most stable devmapper I can get for this kernel?
I could perhaps install from source.

Thanks
Paul
