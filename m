From: Joe Thornber <thornber@redhat.com>
Subject: Re: extracting thin mappings in real time
Date: Thu, 4 Oct 2018 13:56:13 +0100
Message-ID: <20181004125612.GA17205@reti>
References: <CA+fs2JN0evmnJP2yZT144bUOdxaxUydchXrZmLmFVy4F20yfAA@mail.gmail.com>
	<20181003130333.GA20800@reti>
	<CA+fs2JN0FHg_ZGawUACWbJPfCpna1fi7PAMzDem2viNZ-zSthQ@mail.gmail.com>
	<20181003144720.GC20800@reti>
	<CA+fs2JOt5oM7=v8KGdwDuq4mP=GDF4zQTYuug=Fj3QecMmWdLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CA+fs2JOt5oM7=v8KGdwDuq4mP=GDF4zQTYuug=Fj3QecMmWdLA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Thanos Makatos <thanos.makatos@sunlight.io>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Oct 03, 2018 at 04:47:41PM +0100, Thanos Makatos wrote:
> poo metadata object can return this information? I've started looking
> at  thin_bio_map(), is this the best place to start?

See thin-metadata.h

- Joe
