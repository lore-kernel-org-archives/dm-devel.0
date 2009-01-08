From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH] Cluster-aware logging module.
Date: Thu, 8 Jan 2009 12:39:27 -0600
Message-ID: <D74B92B5-0C7F-4CDB-B79C-847D4231D47A@redhat.com>
References: <1229465455.7094.24.camel@hydrogen.msp.redhat.com>
	<20090106214126.GA5591@nik-comp.linuxbox.cz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090106214126.GA5591@nik-comp.linuxbox.cz>
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

I've checked the userspace source code in to LVM2/daemons/clogd.  I  
have not linked it into the general build system for the repository  
yet, so you will have to 'cd LVM2/daemons/clogd; make; #make install'.

You can choose to use the kernel patch I posted last.  Otherwise, I  
will be posting another kernel patch.  The latest patch removes the  
last set of complaints I received.  (Removes hard-coded values.)  I  
will post this shortly.

  brassow

On Jan 6, 2009, at 3:41 PM, Nikola Ciprich wrote:

> Hi Jonathan,
> I'd like to test Your clustered mirror patches, do You have some  
> newer version in the meantime?
> Ot is this one the latest one?
> thanks a lot in advance!
> BR
> nik
