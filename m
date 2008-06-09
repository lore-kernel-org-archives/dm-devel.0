From: "January Weiner" <january@uni-muenster.de>
Subject: Re: Questin about device mapper, Debian and devices
Date: Mon, 9 Jun 2008 17:42:44 +0200
Message-ID: <454237550806090842o6641045dh6993dea16616ea89@mail.gmail.com>
References: <454237550806090308j20a29e58w7dc22b89ce055e5@mail.gmail.com>
	<20080609145318.GA26029@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080609145318.GA26029@us.ibm.com>
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

> Remove /etc/multipath.conf file if you have. Same file can be used to
> blacklist if you want to apply multipath to exclude few devices.

There is no such file. Assuming I enter the blacklist, how do I
restart the service so that I no longer have the mapping present? with
/etc/init.d/multipath-tools restart?

j.

--=20
------------ January Weiner 3  ---------------------+---------------
Division of Bioinformatics, University of Muenster  |  Schlo=DFplatz 4
(+49)(251)8321634                                   |  D48149 M=FCnster
http://www.uni-muenster.de/Evolution/ebb/           |  Germany
