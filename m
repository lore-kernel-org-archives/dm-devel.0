From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Weird discrepancy between /dev/mapper/* and /dev/dm-*
	devices breaks lilo
Date: Wed, 31 Jan 2007 15:06:35 +0000
Message-ID: <20070131150635.GB21980@agk.surrey.redhat.com>
References: <20070131104737.GA29370@bee.dooz.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070131104737.GA29370@bee.dooz.org>
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

On Wed, Jan 31, 2007 at 11:47:37AM +0100, Lo=EFc Minier wrote:
>  When issuing the same dmsetup commands on two device nodes with the
>  same major/minor, the results are puzzling:

The device-mapper ioctls allow mapped devices to be referenced in three w=
ays:
  name
  uuid
  major+minor

The uuid is optional.

dmsetup provides a command line wrapper around the ioctls.  It also
maintains the /dev/mapper directory, creating inodes there called 'name'.
It understands the above three ways of referencing devices: it does not
depend on the existing contents of '/dev'.

Some distributions chose to configure udev to create /dev/dm-N inodes whe=
re
N is the minor number.  (I have always discouraged that as a recipe for
confusion: I believe that using configurable names is a better approach.)

Alasdair
--=20
agk@redhat.com
