From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH 3/6] dm raid45 target: introduce message parser
Date: Mon, 22 Jun 2009 13:16:33 +0200
Message-ID: <1245669393.7390.17.camel@o>
References: <4a368307.0ftb1qz35ivVfvJZ%heinzm@redhat.com>
	<68823474-5CFB-44EC-85F0-CE5FA8A5CF1D@redhat.com>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <68823474-5CFB-44EC-85F0-CE5FA8A5CF1D@redhat.com>
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

On Fri, 2009-06-19 at 12:35 -0500, Jonathan Brassow wrote:
> On Jun 15, 2009, at 12:21 PM, heinzm@redhat.com wrote:
> 
> > This patch adds the dm-message parser module.
> 
> Would it be ok to leave this out?  Would you be willing to implement  
> some simple parsing in 'raid_message' for now?

If arguments go the way, that this ain't buy us much code sharing with
other targets, sure.

More opinions from others ?

> 
> Maybe there are benefits that I am not seeing?

I did it to allow for argument parsing code to be sharable amongst
targets message methods aiming to simplify parsing in multiple targets.

Heinz

> 
>   brassow
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
