From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 0/1] add option to output JSON for multipathd
 command
Date: Wed, 4 May 2016 18:17:11 -0700
Message-ID: <572A9F17.5080208@sandisk.com>
References: <1462393428-13929-1-git-send-email-tgill@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1462393428-13929-1-git-send-email-tgill@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Todd Gill <tgill@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 05/04/16 13:23, Todd Gill wrote:
> I had earlier sent an email to dm-devel proposing we add a feature
> in multipathd to output multipath map topology in JSON format. This
> patch contains to the code for that feature.
>
> Having an option for the  CLI to output in JSON would allow higher
> level applications to more easily monitor/manage multipath.
>
> I thought it was best to take advantage of some of the existing
> snprintf_xxx functions rather than adding a library dependency
> to multipathd.
>
> Will add code for groups next if this is accepted.

XML is better standardized than JSON, so why to use JSON? An overview of 
the advantages of XML is available on 
http://www.yegor256.com/2015/11/16/json-vs-xml.html. A good overview of 
JSON and also of some of its disadvantages is available on 
https://en.wikipedia.org/wiki/JSON.

Sorry that I missed your previous e-mail about this topic.

Bart.
