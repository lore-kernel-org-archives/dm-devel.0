From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 0/3] dm-target: target_type improvements
Date: Fri, 2 Jan 2009 18:12:15 +0000
Message-ID: <20090102181215.GF11060@agk.fab.redhat.com>
References: <1229660385-17153-1-git-send-email-crquan@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1229660385-17153-1-git-send-email-crquan@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Cheng Renquan <crquan@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Dec 19, 2008 at 12:19:42PM +0800, crquan@gmail.com wrote:
> From: Cheng Renquan <crquan@gmail.com>
> 3. totally remove tt_internal;
> The 3rd patch may be controversial,
> But I still think it's worth it:

Well now that it's down to just one field for linking items I'm inclined to
agree that it's OK.

Do you (or anyone else) have any interest in creating and testing similar sets
of patches for the other parts of device-mapper that use the same construction?

Alasdair
-- 
agk@redhat.com
