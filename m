From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: dm-snapshot transient data
Date: Fri, 31 Jul 2009 17:26:18 -0500
Message-ID: <AC4C99F9-9BAB-4CB3-8AFC-2EEB51ED6F46@redhat.com>
References: <59a2a3420907311440odaec3c2l7c27f051a667796@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <59a2a3420907311440odaec3c2l7c27f051a667796@mail.gmail.com>
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

I don't think many people (anyone?) uses the transient exception store  
for that very reason.

The future merge operation *could* allow you to at least merge any  
changes into the origin before you delete the snapshot, but I'm not  
sure anyone will pay attention to that exception store.

Since you are writing data to the COW anyway, you might as well write  
the metadata information too (use persistent exception store).

  brassow

On Jul 31, 2009, at 4:40 PM, Guilherme Moro wrote:

> Hello list,
>
> I'm newcomer here, so nice to meet you all!
>
> Is there any way to access the data of the COW device ( in transient  
> mode) right before discard the changes?
> I tried to figure out myself, but cant find a clean way to get the  
> data before it gets discarded, and dont know exactly how to figure  
> what blocks are saved in the COW partition.
>
> thanks.
>
> Guilherme Moro
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
