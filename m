From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm crypt: Add comments to better describe crypto
 processing logic.
Date: Fri, 15 May 2015 15:24:58 -0400
Message-ID: <20150515192458.GB29056@redhat.com>
References: <20150504213254.GA27445@debian>
	<1431702025-17925-1-git-send-email-mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1431702025-17925-1-git-send-email-mbroz@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, May 15 2015 at 11:00am -0400,
Milan Broz <mbroz@redhat.com> wrote:

> A crypto driver can process request synchronously or asynchronously
> and can use internal driver queue to backlog requests.
> Add some comments to clarify internal logic and completion return codes.
> 
> Signed-off-by: Milan Broz <mbroz@redhat.com>

Thanks Milan, I picked this up for 4.2.
