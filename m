From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: Re: adding mirroring feature
Date: Tue, 22 Mar 2005 14:25:58 -0600
Message-ID: <d3245d1224f8c07e59eabb2eeda0a51b@redhat.com>
References: <20050318145323.39808.qmail@web41606.mail.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v619.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050318145323.39808.qmail@web41606.mail.yahoo.com>
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

On Mar 18, 2005, at 8:53 AM, pritam bhavsar wrote:

> I am adding the mirroring feature to LVM2 tools that means creating a 
> LV on VG that contains two PVs and whatever data I am writing to LV it 
> should get mirrored to the second PV under the same VG..

For user-space (lvm2 tools):
Mirroring is being actively worked on.  There is a bit of clean-up to 
be done followed by the push to include the changes in the main 
repository.  We are hoping that they will start appearing over the 
coming weeks.

>  for this purpose I have already developed the command for lvcreate 
> but I am not getting the idea about where to make changes in dm ... 
> can anybody help me...that where should I make changes in dm files etc 
> etc?

What changes are you looking to make in dm?  I am currently working to 
ready the mirror target for general use (dm-raid1.c dm-log.c).

  brassow
