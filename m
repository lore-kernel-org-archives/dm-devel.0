From: folkert <folkert@vanheusden.com>
Subject: software raid & intent bitmap on other device
Date: Thu, 30 May 2013 12:25:26 +0200
Message-ID: <20130530102525.GM10944@belle.intranet.vanheusden.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

I'm going to setup a software raid-1 and would like to improve its
performance by storing things like the write intent bitmap (and fs
journals but that's not relevant here) on a seperate disk. In this case
and SSD.
I was wondering: as SSDs frequently seem to die, what happens with the
raid? Things will probably oops, panic and crash but after the reboot:
will it refuse to come up? Or will it come up and just to a complete
resync?


Regards,

Folkert van Heusden

-- =

MultiTail ist eine flexible Applikation um Logfiles und Kommando
Eingaben zu =FCberpr=FCfen. Inkl. Filter, Farben, Zusammenf=FChren,
Ansichten etc. http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
