From: malahal@us.ibm.com
Subject: Re: Need Help
Date: Thu, 17 Jan 2008 12:14:00 -0800
Message-ID: <20080117201400.GA7083@us.ibm.com>
References: <EEBC5C82F965344199BFA3E6047FE13302E8E1@SAUSEXMB2.amd.com>
	<1200596524.7183.76.camel@linuxchandra>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1200596524.7183.76.camel@linuxchandra>
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

Chandra Seetharaman [sekharan@us.ibm.com] wrote:
> On Thu, 2008-01-17 at 12:40 -0600, Nath, Varun wrote:
> > I used the /dev/mapper/mpath# also in the fstab but that did not help.
> 
> That is odd.
> 
> When the system boots up completely, do you see the multipath devices,
> or you explicitly run the multipath command to make the multipath
> devices show up ?

RHEL doesn't require anything other than the mere presence of
/etc/mulipath.conf to configure multipath devices. BUT there was a bug
where it was not able to properly use the /etc/multipath.conf file at
boot time when the file system (/var) is mounted read-only. So you get
device names based SCSI WWN. There is an init script that essentially
runs multipathd that renames the 'SCSI WWN' names to user friendly
names (apart from doing the job of path health check).

Make sure you start the multipath[d] rc script.

-Malahal.
