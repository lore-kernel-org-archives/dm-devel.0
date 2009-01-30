From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: [PATCHES] new barriers - 2
Date: Fri, 30 Jan 2009 11:15:26 +0100
Message-ID: <4982D33E.60000@wpkg.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

> Here I announce 2nd version my new barrier support patches:
> http://people.redhat.com/mpatocka/patches/kernel/barriers/
> 
> They are against 2.6.29-rc3.
> 
> The most important enhancement is that with these patches, device mapper 
> is able to send barrier requests to lower devices.

I guess it still won't work for those using LVM on md (Linux software 
RAID) because md lacks barrier support? Do you know if someone is 
working on it?


-- 
Tomasz Chmielewski
http://wpkg.org
