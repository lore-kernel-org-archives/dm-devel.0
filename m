From: =?ISO-8859-2?Q?Stanislav_Pol=E1=B9ek?= <sp@linworx.cz>
Subject: multipath device question
Date: Sat, 11 Feb 2006 01:43:54 +0100
Message-ID: <43ED334A.7050009@linworx.cz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi! Let me please start with apology for using the development list to
ask rather end-user question. I am looking for help with multipath
setup. I have a few servers connected to a ibm storage. Two servers have
two qlogic HBAs each. On the first server was created a multipath device
out of all 4 scsi devices/paths. On the second server it is possible to
assemble the same mp device and attach it without problems (there is the
gfs).

However, the third server I would like to connect to the storage has
just one HBA. It's only 1U format and I cannot add anything to it. And
moreover, the visible storage scsi device order there is different.

As I know the mdadm that I used to create the multipath device writes to
the superblock an information about the array, I would like to find out
how much the multipath implementation in the kernel depends on this
information. Would it be a problem to connect the third server to the
storage by assembling the multipath device out of just two scsi
devices/paths instead of four and in addition using scsi devices with
diferrent minor/major numbers?

As I do really doubt that, is there any way how to connect the third
server using the multipath setup?

Thank you very much for your help. I could get the answers by testing,
but these are production servers with terrabytes of data and I cannot
really stop them now for more then just a few minutes.

Stanislav Polasek

- --
#--#--#--#--#--#--#--#--#--#--
Stanislav Polasek
RHCE #804005251615651 / RHCX
LinWorx s.r.o.
sp@linworx.cz / www.linworx.cz
#--#--#--#--#--#--#--#--#--#--
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFD7TNJN6fiEWfPEr8RAoMNAJ9rBRXd9bq66Dmo67sYhJLauDo14wCfQwgs
liIXlFWR8N1E6l9gJiF8EjQ=
=3t6R
-----END PGP SIGNATURE-----
