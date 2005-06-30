From: Lars Marowsky-Bree <lmb@suse.de>
Subject: MPIO + offlined devices
Date: Thu, 30 Jun 2005 16:42:02 +0200
Message-ID: <20050630144202.GL31922@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Summary:

The SCSI stack might set devices to "offline" during certain error
recovery code paths; offline devices fail _all_ IO immediately. These
devices then require special activation again before even the path
checkers can test it again.

We've investigated hacks to make the kernel not offline devices for
"FAILFAST" IO. However, this has proven to be lacking, because the
SCSI error handling stack is somewhat complex to decipher. ;-)

As the "special handling" consists of

	echo 1 >/sys/block/<sda>/device/online

only, my proposal would be to do this every single time before we invoke
a path checker anywhere, at least for SCSI devices (ie, where sg_id is
set).

The most elegant way might be a gateway function: int
call_checker(struct path *pp), which did whatever was necessary and then
called pp->checkerfn(); it could also take care of setting up the
context, opening the fd, figuring out the checkerfn if not yet set etc.

What do you think?


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
