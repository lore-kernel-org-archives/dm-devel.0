From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH 0/9] dm snapshot: shared exception store
Date: Thu, 6 Nov 2008 14:37:11 -0600
Message-ID: <CAAEF849-8EAA-4006-A0C3-58F40A0904B4@redhat.com>
References: <1225109276-16491-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1225109276-16491-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
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

Wouldn't it be nice if we could generalize the creation of the  
exception stores.  Rather than having 'dm_create_[shared/persistent/ 
transient]', we could have 'dm_create_exception_store(<string>)'.   
What happens when cluster snapshots comes around?  That will be  
another exception store.

  brassow

On Oct 27, 2008, at 7:07 AM, FUJITA Tomonori wrote:

> This is the third version of the shared exception store (based on
> Zumastor code). You can find the first and second submission:
