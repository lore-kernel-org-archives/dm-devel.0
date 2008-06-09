From: malahal@us.ibm.com
Subject: Re: Questin about device mapper, Debian and devices
Date: Mon, 9 Jun 2008 09:22:34 -0700
Message-ID: <20080609162234.GA29800@us.ibm.com>
References: <454237550806090308j20a29e58w7dc22b89ce055e5@mail.gmail.com>
	<20080609145318.GA26029@us.ibm.com>
	<454237550806090842o6641045dh6993dea16616ea89@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <454237550806090842o6641045dh6993dea16616ea89@mail.gmail.com>
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

I don't use debian, so I don't know what the defaults are.  "multipath
-F" should remove all multipath mappings. You can use "dmsetup
remove_all" command to remove all device-mapper devices.

-Malahal.

January Weiner [january@uni-muenster.de] wrote:
> > Remove /etc/multipath.conf file if you have. Same file can be used to
> > blacklist if you want to apply multipath to exclude few devices.
> 
> There is no such file. Assuming I enter the blacklist, how do I
> restart the service so that I no longer have the mapping present? with
> /etc/init.d/multipath-tools restart?
> 
> j.
> 
> -- 
> ------------ January Weiner 3  ---------------------+---------------
> Division of Bioinformatics, University of Muenster  |  Schlo?platz 4
> (+49)(251)8321634                                   |  D48149 M?nster
> http://www.uni-muenster.de/Evolution/ebb/           |  Germany
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
