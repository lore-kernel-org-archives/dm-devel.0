From: mylists@montblanc.homeip.net
Subject: error calling out /sbin/scsi_id
Date: Fri, 8 Aug 2008 10:38:24 +0200 (CEST)
Message-ID: <6970f8553dbb14b2b901be06ee4918d7.squirrel@montblanc.homeip.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
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

Hello all,

Why do I get the following error message:
error calling out /sbin/scsi_id -g -u -s /block/sda

after I run multipath for a second time.

Example:

multipath -F         -> everything not used is flushed
multipath            -> mpaths are created
multipath (2nd time) -> error msg

I'd like to understand and avoid this error. Can you point me to any
documentation please?


Thanks,
Josep SERRANO.
