From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: IO controller Mini-Summit 2009
Date: Wed, 14 Oct 2009 13:55:21 -0400
Message-ID: <20091014175521.GG3528@redhat.com>
References: <20091014.212444.179938286.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091014.212444.179938286.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>, xen-devel@lists.xensource.com, Gui Jianfeng <guijianfeng@cn.fujitsu.com>, containers@lists.linux-foundation.org, Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, Dong-Jae Kang <baramsori72@gmail.com>, Akio Takebe <takebe_akio@jp.fujitsu.com>, Jens Axboe <jens.axboe@oracle.com>, Nauman Rafique <nauman@google.com>, Munehiro Ikeda <m-ikeda@ds.jp.nec.com>, Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao <fernando@oss.ntt.co.jp>, Balbir Singh <balbir@linux.vnet.ibm.com>
List-Id: dm-devel.ids

On Wed, Oct 14, 2009 at 09:24:44PM +0900, Ryo Tsuruta wrote:
> Hello,
> 

Hi Ryo,

CCing people who are planning to attend the mini summit either in person
or phone. (As per your list on io mini summit wiki page). Not sure if
everybody is scanning mailing list for update on mini summit.

I am checking out wiki page for more information like Venue. It says the
venue is linux foundation office Japan. Hopefully there is no change in
that information.

What are the conference call details for the people who might want to join
in over phone? Could not find those. Are you yet to post these?

Thanks
Vivek

> I have summarized the topics for the IO controller mini-summit and
> written the ideas seen in the mailing list.
> 
> - The place where IO controller should be implemented
>   - Block layer in conjunction with the IO scheduler
>   - Common layer right above the IO scheduler
>   - CFQ enhancement.
>   - Both block and common layer, users can select whichever controller
>     they want.
>   - VFS layer
> 
> - What kind of bandwidth control policies are needed?
>   - Proportional weight
>   - Enforcing upper limit
>   - Minimum bandwidth guarantee
> 
> - How to handle buffered writes?
>   - Add dirt-ratio in the memory controller
>   - Add bufferred-write-cgroup to track buffered writebacks
>   - A per group per bdi pdflush threads
> 
> - Who should be charged for swap activity?
>   - who requests a page.
>   - who has a page.
>   - All swap activities are charged to the root group.
> 
> And I would also like to discuss about the followings.
> 
> - Extensions of struct bio
>   - Make a bio point to the io_context of a process which creates the
>     I/O request. This allows to pass the IO scheduling class and
>     priority information to IO controller even if the IO is submitted
>     by another process which does not create the request, such as a
>     worker thread.
>   - Add a new flag to struct bio to identify the bio as urgent. This
>     gives IO controller a chance to handle the bio as high
>     priority. This flag should be set if the bio is created for the
>     page-out operation. 
> 
> - Common test methods to verify the functionality of IO controller.
> 
> Please give me comments and suggestions. I may be missing or
> misunderstanding something.
> 
> Thanks,
> Ryo Tsuruta
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
