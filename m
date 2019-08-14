From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 09/16] tests: update pgpolicy tests to work
 with group_paths()
Date: Wed, 14 Aug 2019 21:20:03 +0000
Message-ID: <e7ba9fa26b9e46e4e60441579d5f0bb47d5d83a5.camel@suse.com>
References: <1564763622-31752-1-git-send-email-bmarzins@redhat.com>
	<1564763622-31752-10-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1564763622-31752-10-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <8C15F3522EFA8143B311156E619EE135@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "mkumar@redhat.com" <mkumar@redhat.com>
List-Id: dm-devel.ids

On Fri, 2019-08-02 at 11:33 -0500, Benjamin Marzinski wrote:
> The pgpolicy unit tests now work again, using group_paths().
> test_one_group0(), which was skipped with the old path grouping code
> because it failed, is now working correctly.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  tests/pgpolicy.c | 125 +++++++++++++++++++++++++++++++------------
> ----

Minor nit: The current patch order breaks the tests until this one is
applied. I'd have liked to see this patch right after 04/16.

Martin
