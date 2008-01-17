From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Need Help
Date: Thu, 17 Jan 2008 11:18:07 -0800
Message-ID: <1200597487.7183.78.camel@linuxchandra>
References: <EEBC5C82F965344199BFA3E6047FE13302E8E1@SAUSEXMB2.amd.com>
	<1200596524.7183.76.camel@linuxchandra>
	<110b17190801171109g3bbb71b4o651381a57f78a567@mail.gmail.com>
Reply-To: sekharan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <110b17190801171109g3bbb71b4o651381a57f78a567@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Pradipmaya Maharana <pradipmaya@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2008-01-17 at 11:09 -0800, Pradipmaya Maharana wrote:
> In addition to that, should "dm-" also be under the devnode_blacklilst?
> 
No, that list is for low level devices, not dm.

> Regards,
> Pradipmaya.
> 
> On Jan 17, 2008 11:02 AM, Chandra Seetharaman <sekharan@us.ibm.com> wrote:
> > On Thu, 2008-01-17 at 12:40 -0600, Nath, Varun wrote:
> > > I used the /dev/mapper/mpath# also in the fstab but that did not help.
> >
> > That is odd.
> >
> > When the system boots up completely, do you see the multipath devices,
> > or you explicitly run the multipath command to make the multipath
> > devices show up ?
> >
> >
<snip>
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
