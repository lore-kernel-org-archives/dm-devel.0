From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH 3/6] dm raid45 target: introduce message parser
Date: Fri, 19 Jun 2009 12:35:56 -0500
Message-ID: <68823474-5CFB-44EC-85F0-CE5FA8A5CF1D@redhat.com>
References: <4a368307.0ftb1qz35ivVfvJZ%heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4a368307.0ftb1qz35ivVfvJZ%heinzm@redhat.com>
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

On Jun 15, 2009, at 12:21 PM, heinzm@redhat.com wrote:

> This patch adds the dm-message parser module.

Would it be ok to leave this out?  Would you be willing to implement  
some simple parsing in 'raid_message' for now?

Maybe there are benefits that I am not seeing?

  brassow
