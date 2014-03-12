From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] dm-multipath: Print more explicit
 warnings when dealing with multipath messages
Date: Wed, 12 Mar 2014 18:08:32 -0400
Message-ID: <20140312220831.GA1282@redhat.com>
References: <1391014365-4180-1-git-send-email-jcastillo@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1391014365-4180-1-git-send-email-jcastillo@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jose Castillo <jcastillo@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Jan 29 2014 at 11:52am -0500,
Jose Castillo <jcastillo@redhat.com> wrote:

> The following warning message "Unrecognised multipath message received" is displayed
> in two different situations inside the function multipath_message: when
> the number of arguments passed is invalid and when the string passed in argv[0]
> is not recognized. With this patch, both warnings are more specific to each case
> and is easier to identify where the problem is.
> 
> Signed-off-by: Jose Castillo <jcastillo@redhat.com>

Hi Jose,

I've picked this patch up for 3.15.  It is staged in the 'for-next'
branch of linux-dm.git, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=4a5f0cfea2ba2d765f29f3951e3b993fc76206b2

Thanks,
Mike
