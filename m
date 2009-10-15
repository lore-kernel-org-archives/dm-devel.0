From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: IO controller Mini-Summit 2009
Date: Thu, 15 Oct 2009 10:59:02 +0900 (JST)
Message-ID: <20091015.105902.70196131.ryov@valinux.co.jp>
References: <20091014.212444.179938286.ryov@valinux.co.jp>
	<20091014175521.GG3528@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <20091014175521.GG3528@redhat.com>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: vgoyal@redhat.com
Cc: yoshikawa.takuya@oss.ntt.co.jp, xen-devel@lists.xensource.com, guijianfeng@cn.fujitsu.com, containers@lists.linux-foundation.org, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org, rostedt@goodmis.org, virtualization@lists.linux-foundation.org, taka@valinux.co.jp, yamahata@valinux.co.jp, dm-devel@redhat.com, baramsori72@gmail.com, takebe_akio@jp.fujitsu.com, jens.axboe@oracle.com, nauman@google.com, m-ikeda@ds.jp.nec.com, fernando@oss.ntt.co.jp, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Hi Vivek,

Vivek Goyal <vgoyal@redhat.com> wrote:
> CCing people who are planning to attend the mini summit either in person
> or phone. (As per your list on io mini summit wiki page). Not sure if
> everybody is scanning mailing list for update on mini summit.

Thank you for CCing people. I'll add all prospective attendees to Cc
list when I post the information on mini summit.

> I am checking out wiki page for more information like Venue. It says the
> venue is linux foundation office Japan. Hopefully there is no change in
> that information.

There is no change in the venue.
 
> What are the conference call details for the people who might want to join
> in over phone? Could not find those. Are you yet to post these?

Here is the phone number of the conference call.
number +1-218-936-7999
passcode 374489#

I've also added the phone number on the web site.
http://sourceforge.net/apps/trac/ioband/wiki/iosummit

Thank you for your help.
Ryo Tsuruta

> 
> Thanks
> Vivek
> 
> > I have summarized the topics for the IO controller mini-summit and
> > written the ideas seen in the mailing list.
> > 
> > - The place where IO controller should be implemented
> >   - Block layer in conjunction with the IO scheduler
> >   - Common layer right above the IO scheduler
> >   - CFQ enhancement.
> >   - Both block and common layer, users can select whichever controller
> >     they want.
> >   - VFS layer
> > 
> > - What kind of bandwidth control policies are needed?
> >   - Proportional weight
> >   - Enforcing upper limit
> >   - Minimum bandwidth guarantee
> > 
> > - How to handle buffered writes?
> >   - Add dirt-ratio in the memory controller
> >   - Add bufferred-write-cgroup to track buffered writebacks
> >   - A per group per bdi pdflush threads
> > 
> > - Who should be charged for swap activity?
> >   - who requests a page.
> >   - who has a page.
> >   - All swap activities are charged to the root group.
> > 
> > And I would also like to discuss about the followings.
> > 
> > - Extensions of struct bio
> >   - Make a bio point to the io_context of a process which creates the
> >     I/O request. This allows to pass the IO scheduling class and
> >     priority information to IO controller even if the IO is submitted
> >     by another process which does not create the request, such as a
> >     worker thread.
> >   - Add a new flag to struct bio to identify the bio as urgent. This
> >     gives IO controller a chance to handle the bio as high
> >     priority. This flag should be set if the bio is created for the
> >     page-out operation. 
> > 
> > - Common test methods to verify the functionality of IO controller.
> > 
> > Please give me comments and suggestions. I may be missing or
> > misunderstanding something.
> > 
> > Thanks,
> > Ryo Tsuruta
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
