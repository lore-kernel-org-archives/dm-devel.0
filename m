From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 03/16] tests: add path grouping policy unit
	tests.
Date: Wed, 14 Aug 2019 21:38:04 +0000
Message-ID: <439ed044f9e9b2986e32f7c393367c16eb787a4a.camel@suse.com>
References: <1564763622-31752-1-git-send-email-bmarzins@redhat.com>
	<1564763622-31752-4-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1564763622-31752-4-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <FEB16C9133CCDB41BA61CAD02F10DB68@namprd18.prod.outlook.com>
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
> In preparation for changing the path grouping code, add some unit
> tests
> to verify that it works correctly. The only test that currently fails
> (and so it being skipped) is using MULTIBUS when mp->paths is empty.
> All
> the other path grouping policies free mp->paths, even if it is empty.
> one_group() should as well. This will be fixed when the path grouping
> code is updated.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
