From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] thin_dump: added --device-id, --skip-mappings,
 and new output --format's
Date: Thu, 17 Mar 2016 15:45:54 +0000
Message-ID: <20160317154553.GC4033@rh-vpn>
References: <alpine.LRH.2.11.1603150104370.19675@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1603150104370.19675@mail.ewheeler.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Wheeler <dm-devel@lists.ewheeler.net>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

If you're skipping the mappings does the new thin_ls provide enough
information for you?

- Joe

On Tue, Mar 15, 2016 at 01:45:15AM +0000, Eric Wheeler wrote:
> Hi Joe,
> 
> Please review the patch below when you have a moment.  I am interested in 
> your feedback, and also interested in having this functionality merged 
> upstream.  This was written against thin-provisioning-tools.git tag 
> v0.5.6.
> 
> We use thin_dump on live dm-thin metadata snapshots all the time.  In our 
> case, we want to dump the XML for new (snapshot) volumes instead of 
> dumping the entire 16gb metadata device (37.8% used) which takes ~20-30 
> minutes instead of ~5 seconds for a single volume with --device-id.
> 
> I started by adding --device-id to pass the `block_address dev_id` and 
> skip the call to emit_mappings() within mapping_tree_emitter::visit() 
> unless the dev_id matches --device-id as passed to thin_dump.  
> 
> It is sometimes nice to list all of the device supers without waiting for 
> emit_mappings() so I added the --skip-mappings option.  This allows you to 
> get the dev_id without reading the mappings:
> 	thin_dump --skip-mappings -m /dev/mapper/vg-p_tmeta
> 
> Like `bool repair`, I added skip_mappings and dev_id as arguments to 
> thin_provisioning::metadata_dump() and passed them down to 
> mapping_tree_emitter with new members set_skip_mappings() and set_dev_id() 
> to set private attributes (default values are assigned in 
> metadata_dumper.h in case of backward compatible calls).
> 
> We work with the device metadata in a simplified format, and without 
> superblock information:
> 
> 	origin_offset:length:tdata_offset (hence, "o:L:d" or "old") 
> 
> Therefore, the output --format 'old' was added.  I added the format 'null' 
> as well for benchmarking purposes so the ostream needn't write large 
> volumes of text to /dev/null.  
> 
> Benchmarks of the various formats on our sample metadata snapshot on an 
> idle machine:
> 
> for i in xml human_readable old null; do
> 	time thin_dump -m -f $i /dev/mapper/vg-p_tmeta -o /dev/null
> done
> 
> 	real		user		sys
> xml	29:01.27	25:35.87	01:54.49
> human	27:39.81	24:12.90	01:52.39
> old	27:07.71	23:40.64	01:52.97
> null	23:39.38	21:17.22	00:49.04
> 
> I have this as a branch in bitbucket if you prefer to see it online:
>   
> https://bitbucket.org/ewheelerinc/thin-provisioning-tools/branch/v0.5.6-device-id
>   or
> git pull https://bitbucket.org/ewheelerinc/thin-provisioning-tools.git v0.5.6-device-id
> 
> 
> --
> Eric Wheeler
> 
> 
> diff --git a/thin-provisioning/thin_dump.cc b/thin-provisioning/thin_dump.cc
> index 191acb5..7df5d85 100644
> --- a/thin-provisioning/thin_dump.cc
> +++ b/thin-provisioning/thin_dump.cc
> @@ -22,6 +22,8 @@
>  #include <libgen.h>
>  
>  #include "human_readable_format.h"
> +#include "old_format.h"
> +#include "null_format.h"
>  #include "metadata_dumper.h"
>  #include "metadata.h"
>  #include "xml_format.h"
> @@ -36,6 +38,8 @@ using namespace thin_provisioning;
>  struct flags {
>  	bool find_metadata_snap;
>  	bool repair;
> +	block_address dev_id;
> +	bool skip_mappings;
>  };
>  
>  namespace {
> @@ -49,12 +53,16 @@ namespace {
>  				e = create_xml_emitter(out);
>  			else if (format == "human_readable")
>  				e = create_human_readable_emitter(out);
> +			else if (format == "old")
> +				e = create_old_emitter(out);
> +			else if (format == "null")
> +				e = create_null_emitter(out);
>  			else {
>  				cerr << "unknown format '" << format << "'" << endl;
>  				exit(1);
>  			}
>  
> -			metadata_dump(md, e, flags.repair);
> +			metadata_dump(md, e, flags.repair, flags.skip_mappings, flags.dev_id);
>  
>  		} catch (std::exception &e) {
>  			cerr << e.what() << endl;
> @@ -77,10 +85,12 @@ namespace {
>  		out << "Usage: " << cmd << " [options] {device|file}" << endl
>  		    << "Options:" << endl
>  		    << "  {-h|--help}" << endl
> -		    << "  {-f|--format} {xml|human_readable}" << endl
> +		    << "  {-f|--format} {xml|human_readable|old|null}" << endl
>  		    << "  {-r|--repair}" << endl
>  		    << "  {-m|--metadata-snap} [block#]" << endl
>  		    << "  {-o <xml file>}" << endl
> +		    << "  {-d device_id}" << endl
> +		    << "  {-s|--skip-mappings}" << endl
>  		    << "  {-V|--version}" << endl;
>  	}
>  }
> @@ -89,17 +99,20 @@ int thin_dump_main(int argc, char **argv)
>  {
>  	int c;
>  	char const *output = NULL;
> -	const char shortopts[] = "hm::o:f:rV";
> +	const char shortopts[] = "hm::o:sd:f:rV";
>  	char *end_ptr;
>  	string format = "xml";
>  	block_address metadata_snap = 0;
>  	struct flags flags;
> -	flags.find_metadata_snap = flags.repair = false;
> +	flags.find_metadata_snap = flags.repair = flags.skip_mappings = false;
> +	flags.dev_id = -1;
>  
>  	const struct option longopts[] = {
>  		{ "help", no_argument, NULL, 'h'},
>  		{ "metadata-snap", optional_argument, NULL, 'm' },
>  		{ "output", required_argument, NULL, 'o'},
> +		{ "skip-mappings", no_argument, NULL, 's'},
> +		{ "device-id", required_argument, NULL, 'd'},
>  		{ "format", required_argument, NULL, 'f' },
>  		{ "repair", no_argument, NULL, 'r'},
>  		{ "version", no_argument, NULL, 'V'},
> @@ -120,6 +133,19 @@ int thin_dump_main(int argc, char **argv)
>  			flags.repair = true;
>  			break;
>  
> +		case 's':
> +			flags.skip_mappings = true;
> +			break;
> +
> +		case 'd':
> +			flags.dev_id = strtoull(optarg, &end_ptr, 10);
> +			if (end_ptr == optarg) {
> +				cerr << "couldn't parse <device_id>" << endl;
> +				usage(cerr, basename(argv[0]));
> +				return 1;
> +			}
> +			break;
> +
>  		case 'm':
>  			if (optarg) {
>  				metadata_snap = strtoull(optarg, &end_ptr, 10);
> @@ -147,6 +173,12 @@ int thin_dump_main(int argc, char **argv)
>  		}
>  	}
>  
> +	if (format != "old" && flags.dev_id < 0) {
> +		cerr << "Output format 'old' must specify --device-id" << endl;
> +		return 1;
> +	}
> +
> +
>  	if (argc == optind) {
>  		cerr << "No input file provided." << endl;
>  		usage(cerr, basename(argv[0]));
> diff --git a/thin-provisioning/metadata_dumper.h b/thin-provisioning/metadata_dumper.h
> index c96d22e..9d9814e 100644
> --- a/thin-provisioning/metadata_dumper.h
> +++ b/thin-provisioning/metadata_dumper.h
> @@ -28,7 +28,7 @@ namespace thin_provisioning {
>  	// Set the @repair flag if your metadata is corrupt, and you'd like
>  	// the dumper to do it's best to recover info.  If not set, any
>  	// corruption encountered will cause an exception to be thrown.
> -	void metadata_dump(metadata::ptr md, emitter::ptr e, bool repair);
> +	void metadata_dump(metadata::ptr md, emitter::ptr e, bool repair, bool skip_mappings = false, block_address dev_id = -1);
>  }
>  
>  //----------------------------------------------------------------
> diff --git a/thin-provisioning/metadata_dumper.cc b/thin-provisioning/metadata_dumper.cc
> index db656ee..55cbae8 100644
> --- a/thin-provisioning/metadata_dumper.cc
> +++ b/thin-provisioning/metadata_dumper.cc
> @@ -171,23 +171,31 @@ namespace {
>  			  dd_(dd),
>  			  repair_(repair),
>  			  damage_policy_(damage_policy) {
> +				  dev_id_ = -1;
> +				  skip_mappings_ = false;
>  		}
>  
> +		void set_dev_id(block_address dev_id) { dev_id_ = dev_id; }
> +		void set_skip_mappings(bool skip) { skip_mappings_ = skip; }
> +
>  		void visit(btree_path const &path, block_address tree_root) {
>  			block_address dev_id = path[0];
>  
>  			dd_map::const_iterator it = dd_.find(path[0]);
>  			if (it != dd_.end()) {
>  				device_tree_detail::device_details const &d = it->second;
> -				e_->begin_device(dev_id,
> -						 d.mapped_blocks_,
> -						 d.transaction_id_,
> -						 d.creation_time_,
> -						 d.snapshotted_time_);
> +				if (dev_id_ == -1UL || dev_id == dev_id_) {
> +					e_->begin_device(dev_id,
> +							 d.mapped_blocks_,
> +							 d.transaction_id_,
> +							 d.creation_time_,
> +							 d.snapshotted_time_);
>  
> -				emit_mappings(tree_root);
> +					if (!skip_mappings_)
> +						emit_mappings(tree_root);
>  
> -				e_->end_device();
> +					e_->end_device();
> +				}
>  
>  			} else if (!repair_) {
>  				ostringstream msg;
> @@ -209,6 +217,8 @@ namespace {
>  		emitter::ptr e_;
>  		dd_map const &dd_;
>  		bool repair_;
> +		block_address dev_id_;
> +		bool skip_mappings_;
>  		mapping_tree_detail::damage_visitor::ptr damage_policy_;
>  	};
>  }
> @@ -216,7 +226,7 @@ namespace {
>  //----------------------------------------------------------------
>  
>  void
> -thin_provisioning::metadata_dump(metadata::ptr md, emitter::ptr e, bool repair)
> +thin_provisioning::metadata_dump(metadata::ptr md, emitter::ptr e, bool repair, bool skip_mappings, block_address dev_id)
>  {
>  	details_extractor de;
>  	device_tree_detail::damage_visitor::ptr dd_policy(details_damage_policy(repair));
> @@ -231,6 +241,11 @@ thin_provisioning::metadata_dump(metadata::ptr md, emitter::ptr e, bool repair)
>  	{
>  		mapping_tree_detail::damage_visitor::ptr md_policy(mapping_damage_policy(repair));
>  		mapping_tree_emitter mte(md, e, de.get_details(), repair, mapping_damage_policy(repair));
> +
> +		mte.set_skip_mappings(skip_mappings);
> +
> +		if (dev_id >= 0)
> +			mte.set_dev_id(dev_id);
>  		walk_mapping_tree(*md->mappings_top_level_, mte, *md_policy);
>  	}
>  
> diff --git a/man8/thin_dump.8 b/man8/thin_dump.8
> index 7a9f785..9e0bf9e 100644
> --- a/man8/thin_dump.8
> +++ b/man8/thin_dump.8
> @@ -26,9 +26,19 @@ in order to put it back onto a metadata
>  
>  This tool cannot be run on live metadata unless the \fB\-\-metadata\-snap\fP option is used.
>  
> -.IP "\fB\-f, \-\-format\fP \fI{xml|human_readable}\fP".
> +.IP "\fB\-f, \-\-format\fP \fI{xml|human_readable|old|null}\fP".
>  Print output in XML or human readable format.
> -
> +.sp
> +The
> +.B old
> +format requires the --device-id option and emits in the
> +following format, one record per line:
> +.B offset:length:tdata_offset
> +(hence, "o:L:d") with units in bytes.
> +.sp
> +The
> +.B null
> +format emits nothing and only walks the tree.
>  .IP "\fB\-r, \-\-repair\fP".
>  Repair the metadata whilst dumping it.
>  
> @@ -39,6 +49,17 @@ the thin provisioning device-mapper target, else try the one at block#.
>  See the thin provisioning target documentation on how to create or release
>  a metadata snapshot and retrieve the block number from the kernel.
>  
> +.IP "\fB\-d, \-\-skip\-mappings\fP".
> +Skip emission of the mappings.  This outputs nothing if format is
> +either of
> +.B old
> +or
> +.B null
> +.
> +
> +.IP "\fB\-d, \-\-device\-id\fP".
> +Specify the device_id to be dumped.
> +
>  .IP "\fB\-h, \-\-help\fP".
>  Print help and exit.
>  
> diff --git a/Makefile.in b/Makefile.in
> index e67b300..078bb53 100644
> --- a/Makefile.in
> +++ b/Makefile.in
> @@ -73,6 +73,8 @@ SOURCE=\
>  	persistent-data/validators.cc \
>  	thin-provisioning/device_tree.cc \
>  	thin-provisioning/human_readable_format.cc \
> +	thin-provisioning/old_format.cc \
> +	thin-provisioning/null_format.cc \
>  	thin-provisioning/mapping_tree.cc \
>  	thin-provisioning/metadata.cc \
>  	thin-provisioning/metadata_checker.cc \
> diff --git a/thin-provisioning/old_format.h b/thin-provisioning/old_format.h
> new file mode 100644
> index 0000000..dba69e9
> --- /dev/null
> +++ b/thin-provisioning/old_format.h
> @@ -0,0 +1,34 @@
> +// Copyright (C) 2011 Red Hat, Inc. All rights reserved.
> +//
> +// This file is part of the thin-provisioning-tools source.
> +//
> +// thin-provisioning-tools is free software: you can redistribute it
> +// and/or modify it under the terms of the GNU General Public License
> +// as published by the Free Software Foundation, either version 3 of
> +// the License, or (at your option) any later version.
> +//
> +// thin-provisioning-tools is distributed in the hope that it will be
> +// useful, but WITHOUT ANY WARRANTY; without even the implied warranty
> +// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +// GNU General Public License for more details.
> +//
> +// You should have received a copy of the GNU General Public License along
> +// with thin-provisioning-tools.  If not, see
> +// <http://www.gnu.org/licenses/>.
> +
> +#ifndef OLD_FORMAT_H
> +#define OLD_FORMAT_H
> +
> +#include "emitter.h"
> +
> +#include <iosfwd>
> +
> +//----------------------------------------------------------------
> +
> +namespace thin_provisioning {
> +	emitter::ptr create_old_emitter(std::ostream &out);
> +}
> +
> +//----------------------------------------------------------------
> +
> +#endif
> diff --git a/thin-provisioning/old_format.cc b/thin-provisioning/old_format.cc
> new file mode 100644
> index 0000000..52056c8
> --- /dev/null
> +++ b/thin-provisioning/old_format.cc
> @@ -0,0 +1,103 @@
> +// Copyright (C) 2011 Red Hat, Inc. All rights reserved.
> +//
> +// This file is part of the thin-provisioning-tools source.
> +//
> +// thin-provisioning-tools is free software: you can redistribute it
> +// and/or modify it under the terms of the GNU General Public License
> +// as published by the Free Software Foundation, either version 3 of
> +// the License, or (at your option) any later version.
> +//
> +// thin-provisioning-tools is distributed in the hope that it will be
> +// useful, but WITHOUT ANY WARRANTY; without even the implied warranty
> +// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +// GNU General Public License for more details.
> +//
> +// You should have received a copy of the GNU General Public License along
> +// with thin-provisioning-tools.  If not, see
> +// <http://www.gnu.org/licenses/>.
> +
> +#include "old_format.h"
> +
> +#include <iostream>
> +#include <boost/format.hpp>
> +
> +using namespace std;
> +using namespace thin_provisioning;
> +
> +//----------------------------------------------------------------
> +
> +namespace {
> +	template <typename T>
> +	std::ostream &operator << (ostream &out, boost::optional<T> const &maybe) {
> +		if (maybe)
> +			out << *maybe;
> +
> +		return out;
> +	}
> +
> +	class old_emitter : public emitter {
> +	public:
> +		old_emitter(ostream &out)
> +			: out_(out) {
> +		}
> +
> +		void begin_superblock(string const &uuid,
> +				      uint64_t time,
> +				      uint64_t trans_id,
> +				      uint32_t data_block_size,
> +				      uint64_t nr_data_blocks,
> +				      boost::optional<uint64_t> metadata_snap) {
> +			data_block_size_ = data_block_size;
> +		}
> +
> +		void end_superblock() {
> +		}
> +
> +		void begin_device(uint32_t dev_id,
> +				  uint64_t mapped_blocks,
> +				  uint64_t trans_id,
> +				  uint64_t creation_time,
> +				  uint64_t snap_time) {
> +		}
> +
> +		void end_device() {
> +		}
> +
> +		void begin_named_mapping(string const &name) {
> +		}
> +
> +		void end_named_mapping() {
> +		}
> +
> +		void identifier(string const &name) {
> +		}
> +
> +		void range_map(uint64_t origin_begin, uint64_t data_begin, uint32_t time, uint64_t len) {
> +			out_ << (data_block_size_ << 9)*origin_begin
> +				<< ":" << (data_block_size_ << 9)*len
> +				<< ":" << (data_block_size_ << 9)*data_begin
> +				<< endl;
> +		}
> +
> +		void single_map(uint64_t origin_block, uint64_t data_block, uint32_t time) {
> +			out_ << (data_block_size_ << 9)*origin_block
> +				<< ":" << (data_block_size_ << 9)
> +				<< ":" << (data_block_size_ << 9)*data_block
> +			  << endl;
> +		}
> +
> +	private:
> +		ostream &out_;
> +		uint64_t data_block_size_;
> +	};
> +}
> +
> +//----------------------------------------------------------------
> +
> +thin_provisioning::emitter::ptr
> +thin_provisioning::create_old_emitter(ostream &out)
> +{
> +	return emitter::ptr(new old_emitter(out));
> +}
> +
> +//----------------------------------------------------------------
> diff --git a/thin-provisioning/null_format.h b/thin-provisioning/null_format.h
> new file mode 100644
> index 0000000..2688762
> --- /dev/null
> +++ b/thin-provisioning/null_format.h
> @@ -0,0 +1,34 @@
> +// Copyright (C) 2011 Red Hat, Inc. All rights reserved.
> +//
> +// This file is part of the thin-provisioning-tools source.
> +//
> +// thin-provisioning-tools is free software: you can redistribute it
> +// and/or modify it under the terms of the GNU General Public License
> +// as published by the Free Software Foundation, either version 3 of
> +// the License, or (at your option) any later version.
> +//
> +// thin-provisioning-tools is distributed in the hope that it will be
> +// useful, but WITHOUT ANY WARRANTY; without even the implied warranty
> +// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +// GNU General Public License for more details.
> +//
> +// You should have received a copy of the GNU General Public License along
> +// with thin-provisioning-tools.  If not, see
> +// <http://www.gnu.org/licenses/>.
> +
> +#ifndef NULL_FORMAT_H
> +#define NULL_FORMAT_H
> +
> +#include "emitter.h"
> +
> +#include <iosfwd>
> +
> +//----------------------------------------------------------------
> +
> +namespace thin_provisioning {
> +	emitter::ptr create_null_emitter(std::ostream &out);
> +}
> +
> +//----------------------------------------------------------------
> +
> +#endif
> diff --git a/thin-provisioning/null_format.cc b/thin-provisioning/null_format.cc
> new file mode 100644
> index 0000000..b1baa7d
> --- /dev/null
> +++ b/thin-provisioning/null_format.cc
> @@ -0,0 +1,92 @@
> +// Copyright (C) 2011 Red Hat, Inc. All rights reserved.
> +//
> +// This file is part of the thin-provisioning-tools source.
> +//
> +// thin-provisioning-tools is free software: you can redistribute it
> +// and/or modify it under the terms of the GNU General Public License
> +// as published by the Free Software Foundation, either version 3 of
> +// the License, or (at your option) any later version.
> +//
> +// thin-provisioning-tools is distributed in the hope that it will be
> +// useful, but WITHOUT ANY WARRANTY; without even the implied warranty
> +// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +// GNU General Public License for more details.
> +//
> +// You should have received a copy of the GNU General Public License along
> +// with thin-provisioning-tools.  If not, see
> +// <http://www.gnu.org/licenses/>.
> +
> +#include "null_format.h"
> +
> +#include <iostream>
> +
> +using namespace std;
> +using namespace thin_provisioning;
> +
> +//----------------------------------------------------------------
> +
> +namespace {
> +	template <typename T>
> +	std::ostream &operator << (ostream &out, boost::optional<T> const &maybe) {
> +		if (maybe)
> +			out << *maybe;
> +
> +		return out;
> +	}
> +
> +	class null_emitter : public emitter {
> +	public:
> +		null_emitter(ostream &out)
> +			: out_(out) {
> +		}
> +
> +		void begin_superblock(string const &uuid,
> +				      uint64_t time,
> +				      uint64_t trans_id,
> +				      uint32_t data_block_size,
> +				      uint64_t nr_data_blocks,
> +				      boost::optional<uint64_t> metadata_snap) {
> +		}
> +
> +		void end_superblock() {
> +		}
> +
> +		void begin_device(uint32_t dev_id,
> +				  uint64_t mapped_blocks,
> +				  uint64_t trans_id,
> +				  uint64_t creation_time,
> +				  uint64_t snap_time) {
> +		}
> +
> +		void end_device() {
> +		}
> +
> +		void begin_named_mapping(string const &name) {
> +		}
> +
> +		void end_named_mapping() {
> +		}
> +
> +		void identifier(string const &name) {
> +		}
> +
> +		void range_map(uint64_t origin_begin, uint64_t data_begin, uint32_t time, uint64_t len) {
> +		}
> +
> +		void single_map(uint64_t origin_block, uint64_t data_block, uint32_t time) {
> +		}
> +
> +	private:
> +		ostream &out_;
> +	};
> +}
> +
> +//----------------------------------------------------------------
> +
> +thin_provisioning::emitter::ptr
> +thin_provisioning::create_null_emitter(ostream &out)
> +{
> +	return emitter::ptr(new null_emitter(out));
> +}
> +
> +//----------------------------------------------------------------
> diff --git a/thin-provisioning/null_format.h b/thin-provisioning/null_format.h
> new file mode 100644
> index 0000000..2688762
> --- /dev/null
> +++ b/thin-provisioning/null_format.h
> @@ -0,0 +1,34 @@
> +// Copyright (C) 2011 Red Hat, Inc. All rights reserved.
> +//
> +// This file is part of the thin-provisioning-tools source.
> +//
> +// thin-provisioning-tools is free software: you can redistribute it
> +// and/or modify it under the terms of the GNU General Public License
> +// as published by the Free Software Foundation, either version 3 of
> +// the License, or (at your option) any later version.
> +//
> +// thin-provisioning-tools is distributed in the hope that it will be
> +// useful, but WITHOUT ANY WARRANTY; without even the implied warranty
> +// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +// GNU General Public License for more details.
> +//
> +// You should have received a copy of the GNU General Public License along
> +// with thin-provisioning-tools.  If not, see
> +// <http://www.gnu.org/licenses/>.
> +
> +#ifndef NULL_FORMAT_H
> +#define NULL_FORMAT_H
> +
> +#include "emitter.h"
> +
> +#include <iosfwd>
> +
> +//----------------------------------------------------------------
> +
> +namespace thin_provisioning {
> +	emitter::ptr create_null_emitter(std::ostream &out);
> +}
> +
> +//----------------------------------------------------------------
> +
> +#endif
> diff --git a/thin-provisioning/null_format.cc b/thin-provisioning/null_format.cc
> new file mode 100644
> index 0000000..b1baa7d
> --- /dev/null
> +++ b/thin-provisioning/null_format.cc
> @@ -0,0 +1,92 @@
> +// Copyright (C) 2011 Red Hat, Inc. All rights reserved.
> +//
> +// This file is part of the thin-provisioning-tools source.
> +//
> +// thin-provisioning-tools is free software: you can redistribute it
> +// and/or modify it under the terms of the GNU General Public License
> +// as published by the Free Software Foundation, either version 3 of
> +// the License, or (at your option) any later version.
> +//
> +// thin-provisioning-tools is distributed in the hope that it will be
> +// useful, but WITHOUT ANY WARRANTY; without even the implied warranty
> +// of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +// GNU General Public License for more details.
> +//
> +// You should have received a copy of the GNU General Public License along
> +// with thin-provisioning-tools.  If not, see
> +// <http://www.gnu.org/licenses/>.
> +
> +#include "null_format.h"
> +
> +#include <iostream>
> +
> +using namespace std;
> +using namespace thin_provisioning;
> +
> +//----------------------------------------------------------------
> +
> +namespace {
> +	template <typename T>
> +	std::ostream &operator << (ostream &out, boost::optional<T> const &maybe) {
> +		if (maybe)
> +			out << *maybe;
> +
> +		return out;
> +	}
> +
> +	class null_emitter : public emitter {
> +	public:
> +		null_emitter(ostream &out)
> +			: out_(out) {
> +		}
> +
> +		void begin_superblock(string const &uuid,
> +				      uint64_t time,
> +				      uint64_t trans_id,
> +				      uint32_t data_block_size,
> +				      uint64_t nr_data_blocks,
> +				      boost::optional<uint64_t> metadata_snap) {
> +		}
> +
> +		void end_superblock() {
> +		}
> +
> +		void begin_device(uint32_t dev_id,
> +				  uint64_t mapped_blocks,
> +				  uint64_t trans_id,
> +				  uint64_t creation_time,
> +				  uint64_t snap_time) {
> +		}
> +
> +		void end_device() {
> +		}
> +
> +		void begin_named_mapping(string const &name) {
> +		}
> +
> +		void end_named_mapping() {
> +		}
> +
> +		void identifier(string const &name) {
> +		}
> +
> +		void range_map(uint64_t origin_begin, uint64_t data_begin, uint32_t time, uint64_t len) {
> +		}
> +
> +		void single_map(uint64_t origin_block, uint64_t data_block, uint32_t time) {
> +		}
> +
> +	private:
> +		ostream &out_;
> +	};
> +}
> +
> +//----------------------------------------------------------------
> +
> +thin_provisioning::emitter::ptr
> +thin_provisioning::create_null_emitter(ostream &out)
> +{
> +	return emitter::ptr(new null_emitter(out));
> +}
> +
> +//----------------------------------------------------------------
> 
